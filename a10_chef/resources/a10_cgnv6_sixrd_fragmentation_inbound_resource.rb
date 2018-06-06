resource_name :a10_cgnv6_sixrd_fragmentation_inbound

property :a10_name, String, name_property: true
property :a10_action, ['drop','ipv4','ipv6','send-icmpv6']
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/cgnv6/sixrd/fragmentation/"
    get_url = "/axapi/v3/cgnv6/sixrd/fragmentation/inbound"
    a10_name = new_resource.a10_name
    uuid = new_resource.uuid

    params = { "inbound": {"action": a10_action,
        "uuid": uuid,} }

    params[:"inbound"].each do |k, v|
        if not v 
            params[:"inbound"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating inbound') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/sixrd/fragmentation/inbound"
    a10_name = new_resource.a10_name
    uuid = new_resource.uuid

    params = { "inbound": {"action": a10_action,
        "uuid": uuid,} }

    params[:"inbound"].each do |k, v|
        if not v
            params[:"inbound"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["inbound"].each do |k, v|
        if v != params[:"inbound"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating inbound') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/sixrd/fragmentation/inbound"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting inbound') do
            client.delete(url)
        end
    end
end