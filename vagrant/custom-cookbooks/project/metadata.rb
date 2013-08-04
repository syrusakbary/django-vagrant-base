name              "project"
maintainer        "Syrus Akbary"
maintainer_email  "me@syrusakbary.com"
license           "Apache 2.0"
description       "Installs and configures project"
version           "0.0.1"

recipe "project", "Installs and configures project"

depends "python"

%w{ ubuntu debian }.each do |os|
  supports os
end
