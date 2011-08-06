#
# Cookbook Name:: backup
# Recipe:: default
#
# Copyright 2011, Matthew Solt
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


# Install backup gem via rvm
rvm_gem "backup" do
  ruby_string node[:rvm][:default_ruby]
  version node[:backups][:backup_version]
  action :install
end

# Search for backup task data bags (all by default)
backup_tasks = search(:backups, node[:backups][:query_string])

# Create the config file containing the backup tasks
template "#{node[:backups][:backup_path]}/config.rb" do
  source 'config.rb.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables :backup_tasks => backup_tasks
end unless backup_tasks.empty?

