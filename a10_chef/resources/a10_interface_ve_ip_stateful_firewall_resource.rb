resource_name :a10_interface_ve_ip_stateful_firewall

property :a10_name, String, name_property: true
property :uuid, String
property :class_list, String
property :inside, [true, false]
property :outside, [true, false]
property :acl_id, Integer
property :access_list, [true, false]

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/interface/ve/%<ifnum>s/ip/"
    get_url = "/axapi/v3/interface/ve/%<ifnum>s/ip/stateful-firewall"
    uuid = new_resource.uuid
    class_list = new_resource.class_list
    inside = new_resource.inside
    outside = new_resource.outside
    acl_id = new_resource.acl_id
    access_list = new_resource.access_list

    params = { "stateful-firewall": {"uuid": uuid,
        "class-list": class_list,
        "inside": inside,
        "outside": outside,
        "acl-id": acl_id,
        "access-list": access_list,} }

    params[:"stateful-firewall"].each do |k, v|
        if not v 
            params[:"stateful-firewall"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating stateful-firewall') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/interface/ve/%<ifnum>s/ip/stateful-firewall"
    uuid = new_resource.uuid
    class_list = new_resource.class_list
    inside = new_resource.inside
    outside = new_resource.outside
    acl_id = new_resource.acl_id
    access_list = new_resource.access_list

    params = { "stateful-firewall": {"uuid": uuid,
        "class-list": class_list,
        "inside": inside,
        "outside": outside,
        "acl-id": acl_id,
        "access-list": access_list,} }

    params[:"stateful-firewall"].each do |k, v|
        if not v
            params[:"stateful-firewall"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["stateful-firewall"].each do |k, v|
        if v != params[:"stateful-firewall"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating stateful-firewall') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/interface/ve/%<ifnum>s/ip/stateful-firewall"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting stateful-firewall') do
            client.delete(url)
        end
    end
end