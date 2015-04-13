name             'ruby-packager'
maintainer       'Curt Wilhelm'
maintainer_email 'none'
license          'All rights reserved'
description      'packages ruby'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'fpm'

recipe 'ruby-packager::default', 'creates the ruby package'

attribute 'ruby-packager/ruby_version',
  :display_name => 'ruby version',
  :description => 'the ruby version to package',
  :required => 'required',
  :default => '2.2.1'