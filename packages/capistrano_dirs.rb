package :capistrano_dirs do
  noop do
    pre :install, 'mkdir -p /var/www/app/releases/'
    pre :install, 'mkdir -p /var/www/app/shared/'
    pre :install, 'mkdir -p /var/www/app/shared/config'
    pre :install, 'mkdir -p /var/www/app/shared/log'
    pre :install, 'mkdir -p /var/www/app/shared/pids'
    pre :install, 'mkdir -p /var/www/app/shared/system'
    pre :install, 'chown -R deploy:deploy /var/www/app/'
    pre :install, 'chmod -R ug=rwx /var/www/app/'
  end

  verify do
    has_directory '/var/www/app/shared/system'
  end

  requires :git
end