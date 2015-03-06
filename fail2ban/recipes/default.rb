

package "fail2ban" do
  action :upgrade
end

service "fail2ban" do
  supports [ :status => true, :restart => true ]
  action [ :enable, :start ]
end

%w{ fail2ban jail }.each do |cfg|
  template "/etc/fail2ban/#{cfg}.conf" do
    source "#{cfg}.conf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => 'fail2ban')
  end
end

%w{ nginx-auth nginx-proxy nginx-noscript }.each do |cfg|
  template "/etc/fail2ban/filter.d/#{cfg}.conf" do
    source "#{cfg}.conf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => 'fail2ban')
  end
end
