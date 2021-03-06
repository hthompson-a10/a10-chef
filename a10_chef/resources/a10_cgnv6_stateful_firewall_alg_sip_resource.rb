resource_name :a10_cgnv6_stateful_firewall_alg_sip

property :a10_name, String, name_property: true
property :sampling_enable, Array
property :sip_value, ['disable']
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/cgnv6/stateful-firewall/alg/"
    get_url = "/axapi/v3/cgnv6/stateful-firewall/alg/sip"
    sampling_enable = new_resource.sampling_enable
    sip_value = new_resource.sip_value
    uuid = new_resource.uuid

    params = { "sip": {"sampling-enable": sampling_enable,
        "sip-value": sip_value,
        "uuid": uuid,} }

    params[:"sip"].each do |k, v|
        if not v 
            params[:"sip"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating sip') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/stateful-firewall/alg/sip"
    sampling_enable = new_resource.sampling_enable
    sip_value = new_resource.sip_value
    uuid = new_resource.uuid

    params = { "sip": {"sampling-enable": sampling_enable,
        "sip-value": sip_value,
        "uuid": uuid,} }

    params[:"sip"].each do |k, v|
        if not v
            params[:"sip"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["sip"].each do |k, v|
        if v != params[:"sip"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating sip') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/stateful-firewall/alg/sip"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting sip') do
            client.delete(url)
        end
    end
end