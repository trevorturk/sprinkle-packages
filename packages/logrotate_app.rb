package :logrotate_app do
  requires :logrotate, :logrotate_app_logs
end

package :logrotate_app_logs do
  config_file = '/etc/logrotate.d/app'
  config_text = %q[
/var/www/app/shared/log/*.log {
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
end
