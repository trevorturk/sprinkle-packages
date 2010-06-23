package :nginx_with_passenger do
  nginx_version = '0.7.67'
  passenger_version = '2.2.14' # has corresponding version in the nginx_conf package
  noop do
    pre :install, "mkdir -p /var/log/nginx"
    pre :install, "chown deploy:deploy -R /var/log/nginx"
    pre :install, "mkdir -p /opt/nginx"
    pre :install, "wget -P /tmp http://sysoev.ru/nginx/nginx-#{nginx_version}.tar.gz >/dev/null 2>&1"
    pre :install, "tar -xzf /tmp/nginx-#{nginx_version}.tar.gz -C /tmp >/dev/null 2>&1"
    pre :install, "gem install passenger -v #{passenger_version} >/dev/null 2>&1"
    pre :install, "passenger-install-nginx-module --auto --nginx-source-dir=/tmp/nginx-#{nginx_version} --prefix=/opt/nginx --extra-configure-flags=none >/dev/null 2>&1"
  end

  verify do
    has_executable "/opt/nginx/sbin/nginx"
  end

  requires :nginx_logrotate, :nginx_init_d, :libssl
end

package :nginx_logrotate do
  config_file = '/etc/logrotate.d/nginx'
  config_text = %q[
/var/log/nginx/*.log {
  rotate 30
  daily
  missingok
  notifempty
  compress
  delaycompress
  copytruncate
}
].lstrip

  push_text config_text, config_file do
    pre :install, "touch #{config_file} && rm #{config_file} && touch #{config_file}" # clear the file
    post :install, "chmod 0644 #{config_file}"
  end

  requires :logrotate
end

package :nginx_init_d do
  config_file = '/etc/init.d/nginx'
  config_text = %q[
#! /bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

PATH=/opt/nginx/sbin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/nginx/sbin/nginx
NAME=nginx
DESC=nginx

test -x $DAEMON || exit 0

# Include nginx defaults if available
if [ -f /etc/default/nginx ] ; then
        . /etc/default/nginx
fi

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --exec $DAEMON
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid --exec $DAEMON
        sleep 1
        start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  reload)
          echo -n "Reloading $DESC configuration: "
          start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/$NAME.pid --exec $DAEMON
          echo "$NAME."
          ;;
      *)
            N=/etc/init.d/$NAME
            echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
            exit 1
            ;;
    esac

    exit 0
].lstrip

  push_text config_text, config_file do
    post :install, "sudo chmod +x #{config_file}"
    post :install, "sudo /usr/sbin/update-rc.d -f nginx defaults"
  end

  verify do
    has_file config_file
  end
end