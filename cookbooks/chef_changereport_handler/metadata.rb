name 'chef_changereport_handler'
maintainer 'dennyzhang'
maintainer_email 'contact@dennyzhang.com'
license 'All rights reserved'
description 'Chef handler: generate chef report after deploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.5'
issues_url 'https://www.dennyzhang.com'
source_url 'https://www.dennyzhang.com'

supports 'debian'
supports 'ubuntu'

depends 'chef_handler'
depends 'logrotate'
