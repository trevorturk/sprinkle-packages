package :memcached do
  requires :memcached_apt, :memcached_conf, :memcached_logrotate
end

package :memcached_apt do
  apt 'memcached' do
    pre :install, "mkdir -p /var/log/memcached"
    pre :install, "chown deploy:deploy -R /var/log/memcached"
  end

  verify do
    has_executable 'memcached'
  end
end

package :memcached_conf do
  config_file = '/etc/memcached.conf'
  config_text = %q[
# memcached_conf v1
logfile /var/log/memcached/memcached.log
-d
-v
-m 64
-p 11211
-u deploy
-l 127.0.0.1
].lstrip

  push_text config_text, config_file do
    pre :install, "touch #{config_file} && rm #{config_file} && touch #{config_file}" # clear the file
  end

  verify do
    file_contains config_file, "memcached_conf v1"
  end
end

package :memcached_logrotate do
  config_file = '/etc/logrotate.d/memcached'
  config_text = %q[
/var/log/memcached/*.log {
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