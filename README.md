Sprinkle Packages
=================

This is a small collection of packages for Sprinkle.

Sprinkle is a software provisioning tool you can use to build remote
servers. It's kind of like a simple version of Chef-solo, I think.

* <http://github.com/crafterm/sprinkle>
* <http://github.com/opscode/chef>

Example packages include those for nginx with Passenger, Ruby Enterprise,
Monit, memcached, Capistrano, Varnish, etc.

I don't really intend to update these packages, nor do I think they're entirely
complete or exactly right for your needs. I've pulled them out of existing
Sprinkle stacks, so they probably won't even run as-is. Still, they may serve
as a useful starting point for someone.... they've been handy for me.


Usage
-----

    gem install crafterm-sprinkle capistrano capistrano-ext
    sprinkle -s example.rb example.com

See example.rb for the packages that would be installed, and the packages
directory to view the details of those packages.


MIT License
-----------

Copyright (c) 2010 Trevor Turk

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.