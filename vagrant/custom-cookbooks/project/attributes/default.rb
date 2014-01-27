#
# Cookbook Name:: project
# Attribute File:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['project']['dir'] = "/opt/project/"
default['project']['debug'] = false
default['project']['static_dir'] = "#{node['project']['dir']}/static/"
default['project']['socket'] = "/tmp/project.sock"
default['project']['uwsgi_extra'] = ""

default['project']['servername'] = "project.local"
default['project']['serveralias'] = []
default['project']['static_servername'] = "static.project.local"

default['project']['database_name'] = "project"
default['project']['database_user'] = "project"
default['project']['database_password'] = "test"
default['project']['database_connection_max_age'] = 3600
