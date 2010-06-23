Dir.glob(File.join(File.dirname(__FILE__), 'packages/*.rb')).each { |f| require f }
IP = ARGV.first

policy :setup, :roles => :app do
  requires :apt_base
  requires :ssh_keys
  requires :deploy
  requires :capistrano_dirs
  requires :htop
  requires :git
  requires :ruby_enterprise
  requires :nginx_with_passenger
  requires :nginx_conf
  requires :logrotate_app
  requires :sqlite3
  requires :bundler
  requires :libmysql
  requires :memcached
  requires :monit_base
  requires :monit_nginx
  requires :monit_memcached
  requires :monit_start
end

deployment do
  delivery :capistrano do
    set :user, 'root'
    role :app, IP
  end

  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end