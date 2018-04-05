#
# Cookbook Name:: aws-inspector
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2016 eternaltyro
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

##
# Remove the AWS inspector package from the system if it's already
# installed
#
package 'awsagent' do
  case node[:platform]
  when 'redhat', 'centos', 'amazon'
    package_name 'AwsAgent'
  when 'debian', 'ubuntu'
    package_name 'awsagent'
  end
  action   :remove
  notifies :stop, 'service[awsagent]', :immediately
  not_if   { node[:inspector][:enabled] }
end


package 'gnupg2' do # Used for cryptographic verification later on
  action :install
  not_if { platform?('windows') }
end

##
# Download and GPG verification key for AWS inspector binary
#
remote_file "#{Chef::Config[:file_cache_path]}/inspector.gpg" do
  source              node[:inspector][:gpgkey_url]
  use_conditional_get true
  mode                0440
  action              :create
  only_if             { node[:inspector][:enabled] }
  not_if              { platform?('windows') }
  notifies            :run, 'execute[import_key]', :immediately
end

##
# ...and import it, pronto!
#
execute 'import_key' do
  command "gpg2 --import #{Chef::Config[:file_cache_path]}/inspector.gpg"
  action :nothing
  not_if { platform?('windows') }
end

##
# Download the PGP cryptographic signature for the AWS inspector binary
#
remote_file "#{Chef::Config[:file_cache_path]}/install.sig" do
  source              node.default[:inspector][:gpg_signature_url]
  use_conditional_get true
  mode                0o440
  action              :create_if_missing
  only_if             { node[:inspector][:enabled] }
  not_if              { platform?('windows') }
end

##
# Download AWS Inspector installer script
#
remote_file "#{Chef::Config[:file_cache_path]}/inspector" do
  source              node.default[:inspector][:installer_url]
  use_conditional_get true
  mode                0o440
  action              :create
  only_if             { node[:inspector][:enabled] }
  not_if              { platform?('windows') }
end

##
# Install the AWS inspector binary *if* the installer script can be
# cryptographically verified to be from AWS
#
execute 'install-inspector' do
  command "bash #{Chef::Config[:file_cache_path]}/inspector -u false"
  only_if "/usr/bin/gpg2 --verify #{Chef::Config[:file_cache_path]}/install.sig #{Chef::Config[:file_cache_path]}/inspector"
  only_if { node.normal[:inspector][:enabled] }
  not_if { ::File.exist?('/opt/aws/awsagent/bin/awsagent') }
  not_if { platform?('windows') }
  notifies :start, 'service[awsagent]', :immediately
end

# Install for Windows
package 'awsagent' do
  source 'https://d1wk0tztpsntt1.cloudfront.net/windows/installer/latest/AWSAgentInstall.exe'
  only_if { platform?('windows') }
end

##
# AWS inspector service
#
service 'awsagent' do
  supports :start => true, :stop => true, :status => true
  status_command '/opt/aws/awsagent/bin/awsagent status'
  action :nothing
  not_if { platform?('windows') }
end

windows_service 'AWS Agent Service' do
  action [:enable, :start]
  only_if { platform?('windows') }
end

windows_service 'AWS Agent Updater Service' do
  action [:enable, :start]
  only_if { platform?('windows') }
end
