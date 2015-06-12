#
# Cookbook Name:: sensu
# Recipe:: api_service
#
# Copyright 2014, Sonian Inc.
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

execute 'reload_systemctl' do
  command '/usr/bin/systemctl daemon-reload'
  only_if { node.sensu.init_style == 'systemd' }
  action  :nothing
end

link '/usr/lib/systemd/system/sensu-api.service' do
  to        '/usr/share/sensu/systemd/sensu-api.service'
  link_type :hard
  only_if   { node.sensu.init_style == 'systemd' }
  notifies  :run, 'execute[reload_systemctl]', :immediately
  action    :create
end

sensu_service "sensu-api" do
  init_style node.sensu.init_style
  action     [:enable, :start]
end
