package :ruby_enterprise do
  deb 'http://rubyforge.org/frs/download.php/68720/ruby-enterprise_1.8.7-2010.01_amd64.deb' do
    post :install, 'gem update --system >/dev/null 2>&1' # update rubygems
  end

  verify do
    has_executable 'ruby'
    has_executable 'gem'
  end
end

package :bundler do
  gem 'bundler'
  version '0.9.26'

  verify do
    has_executable 'bundle'
  end
end