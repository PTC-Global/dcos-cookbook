resource_name :dcos_user

property :zk_host, String,
         default: 'zk-1.zk:2181,zk-2.zk:2181,zk-3.zk:2181,zk-4.zk:2181,'\
                  'zk-5.zk:2181',
         required: true
property :email, String, required: true
property :user_name, String, required: false  # Name Surname

require 'zookeeper'

include Zookeeper::Constants

load_current_value do
  z = Zookeeper.new(zk_host)
  user_node = z.get(path: "/dcos/users/#{email}")
  if user_node[:rc] == ZOK
    email user_node[:data]
    name_node = z.get(path: "/dcos/users/#{email}/name")
    user_name name_node[:data] if name_node[:rc] == ZOK
  end
end

action :create do
  # If there is a change, remove and replace the current data
  converge_if_changed do
    z = Zookeeper.new(zk_host)
    z.delete(path: "/dcos/users/#{email}")
    z.create(path: "/dcos/users/#{email}", data: email)
    z.create(path: "/dcos/users/#{email}/name", data: user_name)
  end
end

action :delete do
  # Remove the user node from Zookeeper
  z = Zookeeper.new(zk_host)
  z.delete(path: "/dcos/users/#{email}")
end
