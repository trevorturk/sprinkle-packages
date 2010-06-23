package :monit_base do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-base
set daemon 60 with start delay 60 # 1 min monitoring cycle
set logfile syslog facility log_daemon
set mailserver smtp.gmail.com port 587
    username "example@googleappsdomain.com" password "example"
    using tlsv1
    with timeout 30 seconds
set alert you@example.com
].lstrip

  push_text config_text, config_file do
    pre :install, "touch #{config_file}"
    post :install, "echo >/etc/default/monit 'startup=1'" # allow monit startup
  end

  verify do
    file_contains config_file, "monit-base"
  end

  requires :monit_apt
end

package :monit_apt do
  apt 'monit'

  verify do
    has_executable 'monit'
  end
end

package :monit_start do
  noop do
    post :install, '/etc/init.d/monit start'
  end
end

package :monit_ssh do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-ssh
check process sshd with pidfile /var/run/sshd.pid
start program "/etc/init.d/ssh start"
stop program "/etc/init.d/ssh stop"
if failed port 2244 protocol ssh then restart
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "monit-ssh"
  end
end

package :monit_nginx do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-nginx
check process nginx with pidfile /var/run/nginx.pid
start program = "/etc/init.d/nginx start"
stop  program = "/etc/init.d/nginx stop"
if failed host 127.0.0.1 port 80 for 2 cycles then restart
if totalmemory is greater than 60% for 2 cycles then alert
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "monit-nginx"
  end
end

package :monit_memcached do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-memcached
check process memcached with pidfile /var/run/memcached.pid
if failed host 127.0.0.1 port 11211 for 2 cycles then restart
if totalmemory is greater than 20% for 2 cycles then alert
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "monit-memcached"
  end
end

package :monit_nginx_with_varnish do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-nginx-varnish
check process nginx with pidfile /var/run/nginx.pid
start program = "/etc/init.d/nginx start"
stop  program = "/etc/init.d/nginx stop"
if failed host 127.0.0.1 port 8080 for 2 cycles then restart
if totalmemory is greater than 60% for 2 cycles then alert
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "monit-nginx-varnish"
  end
end

package :monit_varnish do
  config_file = '/etc/monitrc'
  config_text = %q[
# monit-varnish
check process varnish with pidfile /var/run/varnishd.pid
start program = "/etc/init.d/varnish start"
stop  program = "/etc/init.d/varnish stop"
if failed host 127.0.0.1 port 80 for 2 cycles then restart
if totalmemory is greater than 60% for 2 cycles then alert
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "monit-varnish"
  end
end