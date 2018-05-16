#
# Cookbook Name:: aws-inspector
# Recipe:: windows
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

# Install for Windows
windows_package 'awsagent' do
  source node[:inspector][:win_installer_url]
  installer_type :custom
  options '-silent'
  only_if { platform?('windows') }
end

##
# AWS inspector service
#
windows_service 'AWSAgent' do
  action [:enable, :start]
  only_if { platform?('windows') }
end

windows_service 'AWSAgentUpdater' do  # AWS Agent Updater service for Windows
  action [:enable, :start]
  only_if { platform?('windows') }
end
