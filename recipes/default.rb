include_recipe "fpm::default"
packages="rpm-build zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel"

packages.split(" ").each do |p|
  package p 
end

directory "/ruby-packager" do
  action :create
end
version =node["ruby-packager"]["ruby_version"]

maj,min,mac = version.split(".")

remote_file "/tmp/ruby-#{version}.tar.gz" do
  source "http://cache.ruby-lang.org/pub/ruby/#{maj}.#{min}/ruby-#{version}.tar.gz"
end

execute "tar -zxvf /tmp/ruby-#{version}.tar.gz"

log "compiling ruby-#{version}"
bash "compile ruby-#{version}" do
   code <<-EOH
  cd /ruby-#{version}
  ./configure --prefix=/usr 
  make ;
  make install DESTDIR=/ruby-packager 
  EOH
end

log "packaging ruby-#{version}"
execute "fpm -s dir -t rpm -n 'ruby' -v #{version} -C /ruby-packager \
 usr/bin usr/lib usr/include usr/share"

execute "rpm -ivh /ruby-#{version}-1.x86_64.rpm"

execute "ruby -v"
log "copied file cookbook directory"
execute "cp /ruby-#{version}-1.x86_64.rpm /vagrant"
