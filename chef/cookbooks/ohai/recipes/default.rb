#
# Cookbook Name:: ohai
# Recipe:: default
#
# Copyright 2010, Opscode, Inc
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

Ohai::Config[:plugin_path] << node.ohai.plugin_path
Chef::Log.info("ohai plugins will be at: #{node.ohai.plugin_path}")

unless ::File.exists?("/usr/sbin/lshw") or ::File.exists?("/usr/bin/lshw")
  p = package "lshw" do
    action :nothing
  end
  p.run_action(:install)
end

d = directory "/opt/tcpdump" do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :nothing
end
d.run_action(:create)

f = cookbook_file "/opt/tcpdump/libpcap-1.1.1.tar.gz" do
  source "libpcap-1.1.1.tar.gz"
  owner 'root'
  group 'root'
  mode 0644
  action :nothing
end
f.run_action(:create)

f = cookbook_file "/opt/tcpdump/tcpdump-4.1.1.tar.gz" do
  source "tcpdump-4.1.1.tar.gz"
  owner 'root'
  group 'root'
  mode 0644
  action :nothing
end
f.run_action(:create)

f = cookbook_file "/opt/tcpdump/tcpdump" do
  source "tcpdump"
  owner 'root'
  group 'root'
  mode 0755
  action :nothing
end
f.run_action(:create)

d = directory node.ohai.plugin_path do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :nothing
end
d.run_action(:create)

rd = remote_directory node.ohai.plugin_path do
  source 'plugins'
  owner 'root'
  group 'root'
  mode 0755
  action :nothing
end
rd.run_action(:create)

o = Ohai::System.new
o.all_plugins
node.automatic_attrs.merge! o.data
