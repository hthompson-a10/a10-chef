resource_name :a10_cgnv6_nat_pool_group_member

property :a10_name, String, name_property: true
property :uuid, String
property :pool_name, String,required: true

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/cgnv6/nat/pool-group/%<pool-group-name>s/member/"
    get_url = "/axapi/v3/cgnv6/nat/pool-group/%<pool-group-name>s/member/%<pool-name>s"
    uuid = new_resource.uuid
    pool_name = new_resource.pool_name

    params = { "member": {"uuid": uuid,
        "pool-name": pool_name,} }

    params[:"member"].each do |k, v|
        if not v 
            params[:"member"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating member') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/nat/pool-group/%<pool-group-name>s/member/%<pool-name>s"
    uuid = new_resource.uuid
    pool_name = new_resource.pool_name

    params = { "member": {"uuid": uuid,
        "pool-name": pool_name,} }

    params[:"member"].each do |k, v|
        if not v
            params[:"member"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["member"].each do |k, v|
        if v != params[:"member"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating member') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/nat/pool-group/%<pool-group-name>s/member/%<pool-name>s"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting member') do
            client.delete(url)
        end
    end
end