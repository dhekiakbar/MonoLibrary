#!/bin/bash
# ====================================================
# MONOLIBRARY QUICK DEPLOYMENT SCRIPT
# ====================================================
# Script ini akan membantu Anda setup aplikasi dengan cepat
# Jalankan: bash deploy.sh
# ====================================================

set -e  # Exit on error

echo "======================================================"
echo "  MONOLIBRARY DEPLOYMENT SCRIPT"
echo "======================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function untuk print colored text
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Check if running as root for certain operations
if [ "$EUID" -eq 0 ]; then 
    print_warning "Running as root. Some operations will be executed with sudo."
fi

# 1. Check Prerequisites
print_info "Checking prerequisites..."

command -v node >/dev/null 2>&1 || { print_error "Node.js is not installed. Please install Node.js first."; exit 1; }
print_success "Node.js found: $(node --version)"

command -v npm >/dev/null 2>&1 || { print_error "npm is not installed. Please install npm first."; exit 1; }
print_success "npm found: $(npm --version)"

command -v mysql >/dev/null 2>&1 || { print_error "MySQL is not installed. Please install MySQL first."; exit 1; }
print_success "MySQL found"

echo ""

# 2. Install Backend Dependencies
print_info "Installing backend dependencies..."
cd backend
npm install
print_success "Backend dependencies installed"
echo ""

# 3. Setup Environment File
print_info "Setting up environment configuration..."
if [ ! -f .env ]; then
    cp .env.example .env
    print_warning ".env file created from .env.example"
    print_warning "PLEASE EDIT backend/.env with your database credentials before continuing!"
    echo ""
    read -p "Press ENTER after you've edited the .env file..."
else
    print_success ".env file already exists"
fi
echo ""

# 4. Generate JWT Secret
print_info "Generating JWT Secret..."
JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(64).toString('hex'))")
print_success "JWT Secret generated"
print_warning "Add this to your .env file if not set:"
echo "JWT_SECRET=$JWT_SECRET"
echo ""
read -p "Press ENTER to continue..."
echo ""

# 5. Database Setup
print_info "Setting up database..."
print_warning "This will DROP existing 'monolibrary' database if it exists!"
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Please enter your MySQL root password:"
    mysql -u root -p < migrations/init_database.sql
    print_success "Database initialized and seeded successfully"
else
    print_warning "Database setup skipped"
fi
echo ""

# 6. Test Backend Connection
print_info "Testing backend..."
if node config/test-db.js; then
    print_success "Database connection successful"
else
    print_error "Database connection failed"
    exit 1
fi

# 7. Setup PM2
print_info "Setting up PM2 process manager..."
if command -v pm2 >/dev/null 2>&1; then
    print_success "PM2 already installed"
else
    print_warning "PM2 not found. Installing PM2..."
    npm install -g pm2
    print_success "PM2 installed"
fi

print_info "Starting application with PM2..."
pm2 delete monolibrary-backend 2>/dev/null || true
pm2 start server.js --name monolibrary-backend
pm2 save
print_success "Application started with PM2"
echo ""

# 8. Show PM2 status
pm2 status
echo ""

# 9. Test API
print_info "Testing API endpoint..."
sleep 2
curl -s http://localhost:3000/api/healthcheck | grep -q "Server its Work" && print_success "API is working!" || print_error "API test failed"
echo ""


#=======APACHE===========
# 10. Apache Configuration
#print_info "Apache configuration..."
#print_warning "To complete Apache setup, run these commands:"
#echo ""
#echo "  sudo a2enmod proxy proxy_http rewrite headers"
#echo "  sudo cp ../monolibrary.conf /etc/apache2/sites-available/"
#echo "  sudo nano /etc/apache2/sites-available/monolibrary.conf  # Edit domain"
#echo "  sudo a2ensite monolibrary.conf"
#echo "  sudo apache2ctl configtest"
#echo "  sudo systemctl restart apache2"
#echo ""


# ====================================================
# 11. Apache Configuration
# ====================================================

# ====================================================
# Detect Linux Distribution
# ====================================================
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    else
        DISTRO=$(uname -s)
        DISTRO_LIKE=""
    fi
}

detect_distro

print_info "Detected distro: $DISTRO"


install_apache() {

    if command -v apachectl >/dev/null || command -v httpd >/dev/null; then
        return
    fi

    case "$DISTRO" in
        arch|manjaro|cachyos)
            sudo pacman -Sy --noconfirm apache
            ;;

        ubuntu|debian)
            sudo apt update
            sudo apt install -y apache2
            ;;

        fedora)
            sudo dnf install -y httpd
            ;;

        centos|rocky|almalinux|rhel)
            sudo yum install -y httpd
            ;;
    esac
}

install_apache


print_info "Configuring Apache..."



case "$DISTRO" in
    arch|manjaro|cachyos)
	print_info "Creating Apache VirtualHost..."
sudo mkdir -p /etc/httpd/conf/extra
sudo tee /etc/httpd/conf/extra/monolibrary.conf >/dev/null <<'EOF'
<VirtualHost *:80>

    ServerName localhost
	
    ProxyRequests Off
    ProxyPreserveHost On

    ProxyPass / http://127.0.0.1:3006/
    ProxyPassReverse / http://127.0.0.1:3006/

    ErrorLog /var/log/httpd/monolibrary-error.log
    CustomLog /var/log/httpd/monolibrary-access.log combined
	
</VirtualHost>
EOF

	# Tambahkan include jika belum ada
	if ! grep -q "Include conf/extra/monolibrary.conf" /etc/httpd/conf/httpd.conf; then
	    echo "" | sudo tee -a /etc/httpd/conf/httpd.conf >/dev/null
	    echo "Include conf/extra/monolibrary.conf" | sudo tee -a /etc/httpd/conf/httpd.conf >/dev/null
	fi

	sudo httpd -t || exit 1
	sudo systemctl enable httpd
	sudo systemctl restart httpd
	
        ;;

    ubuntu|debian)

	sudo tee /etc/apache2/sites-available/monolibrary.conf >/dev/null <<'EOF'
	<VirtualHost *:80>

	    ServerName localhost

	    ProxyRequests Off
	    ProxyPreserveHost On

	    ProxyPass / http://127.0.0.1:3006/
	    ProxyPassReverse / http://127.0.0.1:3006/

	    ErrorLog ${APACHE_LOG_DIR}/monolibrary-error.log
	    CustomLog ${APACHE_LOG_DIR}/monolibrary-access.log combined

	</VirtualHost>
	EOF

	sudo a2enmod proxy proxy_http rewrite headers
	sudo a2ensite monolibrary.conf
	sudo apache2ctl configtest || exit 1
	sudo systemctl restart apache2

        ;;

    fedora|rhel|centos|rocky|almalinux)

        APACHE_CONF="/etc/httpd/conf/httpd.conf"

        for module in proxy proxy_http rewrite headers; do
            sudo sed -i \
                "s/^#LoadModule ${module}_module/LoadModule ${module}_module/" \
                "$APACHE_CONF"
        done

        sudo mkdir -p /etc/httpd/conf.d

        sudo cp ../monolibrary.conf \
            /etc/httpd/conf.d/

        sudo httpd -t || exit 1

        sudo systemctl enable httpd
        sudo systemctl restart httpd
        ;;

    *)

        print_warning "Unsupported distro: $DISTRO"

        print_warning "Please configure Apache manually."

        ;;

esac

# 11. Summary
echo "======================================================"
print_success "DEPLOYMENT COMPLETED!"
echo "======================================================"
echo ""
echo "Next steps:"
echo "  1. Configure Apache (see commands above)"
echo "  2. Access application at http://your-server-ip"
echo "  3. Login with:"
echo "     - Email: admin@monolibrary.com"
echo "     - Password: password123"
echo ""
echo "Useful commands:"
echo "  pm2 status              - Check app status"
echo "  pm2 logs               - View logs"
echo "  pm2 restart monolibrary-backend  - Restart app"
echo ""
print_warning "IMPORTANT: Change default passwords after first login!"
echo "======================================================"
