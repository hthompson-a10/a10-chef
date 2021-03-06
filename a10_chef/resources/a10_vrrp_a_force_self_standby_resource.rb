resource_name :a10_vrrp_a_force_self_standby

property :a10_name, String, name_property: true
property :a10_action, ['enable','disable']
property :vrid, Integer
property :all_partitions, [true, false]

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/vrrp-a/"
    get_url = "/axapi/v3/vrrp-a/force-self-standby"
    a10_name = new_resource.a10_name
    vrid = new_resource.vrid
    all_partitions = new_resource.all_partitions

    params = { "force-self-standby": {"action": a10_action,
        "vrid": vrid,
        "all-partitions": all_partitions,} }

    params[:"force-self-standby"].each do |k, v|
        if not v 
            params[:"force-self-standby"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating force-self-standby') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/vrrp-a/force-self-standby"
    a10_name = new_resource.a10_name
    vrid = new_resource.vrid
    all_partitions = new_resource.all_partitions

    params = { "force-self-standby": {"action": a10_action,
        "vrid": vrid,
        "all-partitions": all_partitions,} }

    params[:"force-self-standby"].each do |k, v|
        if not v
            params[:"force-self-standby"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["force-self-standby"].each do |k, v|
        if v != params[:"force-self-standby"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating force-self-standby') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/vrrp-a/force-self-standby"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting force-self-standby') do
            client.delete(url)
        end
    end
end