// Frontend Configuration
const config = {
    // API Configuration
    API_BASE_URL: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
        ? 'http://localhost:3000/api'  // Development
        : 'http://10.10.10.144:3000/api', // Production
    
    // Environment
    ENVIRONMENT: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
        ? 'development'
        : 'production'
};

// Export for use in other files
window.AppConfig = config;