module.exports = {
  apps: [{
    name: 'monolibrary-backend',
    script: 'server.js',
    cwd: '/var/www/monolibrary/backend',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '/var/log/pm2/monolibrary-backend-error.log',
    out_file: '/var/log/pm2/monolibrary-backend-out.log',
    log_file: '/var/log/pm2/monolibrary-backend.log',
    time: true
  }]
};