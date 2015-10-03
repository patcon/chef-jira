settings = Jira.settings(node)

directory node['jira']['home_path'] do
  owner node['jira']['user']
  action :create
  recursive true
end

template "#{node['jira']['install_path']}/edit-webapp/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  mode '0644'
  only_if { node['jira']['install_type'] == 'war' }
end
