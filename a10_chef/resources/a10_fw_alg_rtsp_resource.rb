resource_name :a10_fw_alg_rtsp

property :a10_name, String, name_property: true
property :default_port_disable, ['default-port-disable']
property :sampling_enable, Array
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/fw/alg/"
    get_url = "/axapi/v3/fw/alg/rtsp"
    default_port_disable = new_resource.default_port_disable
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "rtsp": {"default-port-disable": default_port_disable,
        "sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"rtsp"].each do |k, v|
        if not v 
            params[:"rtsp"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating rtsp') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/fw/alg/rtsp"
    default_port_disable = new_resource.default_port_disable
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "rtsp": {"default-port-disable": default_port_disable,
        "sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"rtsp"].each do |k, v|
        if not v
            params[:"rtsp"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["rtsp"].each do |k, v|
        if v != params[:"rtsp"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating rtsp') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/fw/alg/rtsp"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting rtsp') do
            client.delete(url)
        end
    end
end