package :nginx_conf_app do
  config_file = '/opt/nginx/conf/nginx.conf'
  config_text = %q[
# nginx_conf v1
worker_processes 3; # 1 worker per available core
user deploy deploy; # should match passenger_default_user (below)
pid /var/run/nginx.pid;

events {
  worker_connections 1024; # leave as-is
}

http {
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  passenger_root /usr/local/lib/ruby/gems/1.8/gems/passenger-2.2.14; # has corresponding version in the nginx package
  passenger_ruby /usr/local/bin/ruby;
  passenger_default_user deploy; # should match nginx user (above)
  passenger_max_pool_size 8; # hard limit for max passengers (can be changed if memory available)
  passenger_max_instances_per_app 8; # should match max_pool_size unless multiple apps running
  passenger_pool_idle_time 0;
  rails_app_spawner_idle_time 0;
  rails_framework_spawner_idle_time 0;
  include mime.types;
  default_type application/octet-stream;
  sendfile on;
  tcp_nopush on;
  keepalive_timeout 65;
  gzip on;
  gzip_comp_level 2;
  gzip_buffers 16 8k;
  gzip_disable "MSIE [1-6]\.";
  gzip_proxied any;
  gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

  # when adding new apps, make sure to rotate any log files they might generate
  server {
    listen 80;
    root /var/www/app/current/public;
    passenger_enabled on;
    passenger_use_global_queue on;
    rack_env production;
    client_max_body_size 1M; # this is low and won't support large uploads
    # serve static files without running more rewrite tests
    if (-f $request_filename) {
      break;
    }
    # expires headers
    location ~* \.(ico|css|js|gif|jp?g|png)(\?[0-9]+)?$ {
      expires max;
      break;
    }
    # redirect www to non-www
    if ($host ~* www\.(.*)) {
      set $host_without_www $1;
      rewrite ^(.*)$ http://$host_without_www$1 permanent;
    }
    # disable site via capistrano (cap deploy:web:disable)
    if (-f $document_root/system/maintenance.html) {
      rewrite ^(.*)$ /system/maintenance.html break;
    }
  }
}
].lstrip

  push_text config_text, config_file do
    pre :install, "touch #{config_file} && rm #{config_file} && touch #{config_file}" # clear the file
  end

  verify do
    file_contains config_file, "nginx_conf v1"
  end
end