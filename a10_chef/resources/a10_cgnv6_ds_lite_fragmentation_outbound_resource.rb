resource_name :a10_cgnv6_ds_lite_fragmentation_outbound

property :a10_name, String, name_property: true
property :count, Integer
property :frag_action, ['drop','ipv4','send-icmpv6']
property :df_set, ['drop','ipv4','send-icmp','send-icmpv6']
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/cgnv6/ds-lite/fragmentation/"
    get_url = "/axapi/v3/cgnv6/ds-lite/fragmentation/outbound"
    count = new_resource.count
    frag_action = new_resource.frag_action
    df_set = new_resource.df_set
    uuid = new_resource.uuid

    params = { "outbound": {"count": count,
        "frag-action": frag_action,
        "df-set": df_set,
        "uuid": uuid,} }

    params[:"outbound"].each do |k, v|
        if not v 
            params[:"outbound"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating outbound') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/ds-lite/fragmentation/outbound"
    count = new_resource.count
    frag_action = new_resource.frag_action
    df_set = new_resource.df_set
    uuid = new_resource.uuid

    params = { "outbound": {"count": count,
        "frag-action": frag_action,
        "df-set": df_set,
        "uuid": uuid,} }

    params[:"outbound"].each do |k, v|
        if not v
            params[:"outbound"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["outbound"].each do |k, v|
        if v != params[:"outbound"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating outbound') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/ds-lite/fragmentation/outbound"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting outbound') do
            client.delete(url)
        end
    end
end