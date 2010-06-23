package :apt_base do
  apt 'build-essential' do
    pre :install, 'aptitude update'
  end
end

package :libmysql do
  apt 'libmysqlclient15-dev'
end

package :libssl do
  apt 'libssl-dev'
end

package :htop do
  apt 'htop'

  verify do
    has_executable 'htop'
  end
end

package :git do
  apt 'git-core'

  verify do
    has_executable 'git'
  end
end

package :sqlite3 do
  apt 'sqlite3 libsqlite3-dev libsqlite3-ruby1.8'

  verify do
    has_executable 'sqlite3'
  end
end

package :logrotate do
  apt 'logrotate'

  verify do
    has_executable 'logrotate'
  end
end

package :subversion do
  apt 'subversion'

  verify do
    has_executable 'svn'
  end
end
