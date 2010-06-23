# add your public key to /root/.ssh/authorized_keys for easy ssh login
package :ssh_keys do
  noop do
    pre :install, "ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa"
  end

  verify do
    has_file "/root/.ssh/id_rsa"
  end
end