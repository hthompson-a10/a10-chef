resource_name :a10_fw_server_port

property :a10_name, String, name_property: true
property :health_check_disable, [true, false]
property :protocol, ['tcp','udp'],required: true
property :uuid, String
property :user_tag, String
property :sampling_enable, Array
property :port_number, Integer,required: true
property :a10_action, ['enable','disable']
property :health_check, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/fw/server/%<name>s/port/"
    get_url = "/axapi/v3/fw/server/%<name>s/port/%<port-number>s+%<protocol>s"
    health_check_disable = new_resource.health_check_disable
    protocol = new_resource.protocol
    uuid = new_resource.uuid
    user_tag = new_resource.user_tag
    sampling_enable = new_resource.sampling_enable
    port_number = new_resource.port_number
    a10_name = new_resource.a10_name
    health_check = new_resource.health_check

    params = { "port": {"health-check-disable": health_check_disable,
        "protocol": protocol,
        "uuid": uuid,
        "user-tag": user_tag,
        "sampling-enable": sampling_enable,
        "port-number": port_number,
        "action": a10_action,
        "health-check": health_check,} }

    params[:"port"].each do |k, v|
        if not v 
            params[:"port"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating port') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/fw/server/%<name>s/port/%<port-number>s+%<protocol>s"
    health_check_disable = new_resource.health_check_disable
    protocol = new_resource.protocol
    uuid = new_resource.uuid
    user_tag = new_resource.user_tag
    sampling_enable = new_resource.sampling_enable
    port_number = new_resource.port_number
    a10_name = new_resource.a10_name
    health_check = new_resource.health_check

    params = { "port": {"health-check-disable": health_check_disable,
        "protocol": protocol,
        "uuid": uuid,
        "user-tag": user_tag,
        "sampling-enable": sampling_enable,
        "port-number": port_number,
        "action": a10_action,
        "health-check": health_check,} }

    params[:"port"].each do |k, v|
        if not v
            params[:"port"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["port"].each do |k, v|
        if v != params[:"port"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating port') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/fw/server/%<name>s/port/%<port-number>s+%<protocol>s"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting port') do
            client.delete(url)
        end
    end
end