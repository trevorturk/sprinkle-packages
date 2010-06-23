package :deploy do
  requires :deploy_user, :deploy_id_rsa, :deploy_id_rsa_pub, :deploy_sudoers
end

package :deploy_user do
  noop do
    pre :install, 'groupadd deploy'
    pre :install, 'useradd -m -g deploy deploy'
    pre :install, 'mkdir -p /home/deploy/.ssh'
    pre :install, 'touch /home/deploy/.ssh/id_rsa'
    pre :install, 'touch /home/deploy/.ssh/id_rsa.pub'
    pre :install, 'touch /home/deploy/.ssh/known_hosts'
    pre :install, 'cp /root/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys'
    pre :install, 'chown -R deploy:deploy /home/deploy/.ssh/'
    pre :install, 'chmod 0600 /home/deploy/.ssh/id_rsa'
  end

  verify do
    has_file '/home/deploy/.ssh/id_rsa'
    has_file '/home/deploy/.ssh/authorized_keys'
  end
end

# generate keys to use with your "deploy" user(s), see ssh.rb for an example
package :deploy_id_rsa do
  config_file = '/home/deploy/.ssh/id_rsa'
  config_text = %q[
-----BEGIN RSA PRIVATE KEY----- [etc...]
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "..."
  end
end

package :deploy_id_rsa_pub do
  config_file = '/home/deploy/.ssh/id_rsa.pub'
  config_text = %q[
ssh-rsa [etc...]
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "..."
  end
end

package :deploy_sudoers do
  config_file = '/etc/sudoers'
  config_text = %q[
deploy ALL=NOPASSWD: ALL
].lstrip

  push_text config_text, config_file

  verify do
    file_contains config_file, "deploy ALL=NOPASSWD: ALL"
  end
end