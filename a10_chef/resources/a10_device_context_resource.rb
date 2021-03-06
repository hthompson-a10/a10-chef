resource_name :a10_device_context

property :a10_name, String, name_property: true
property :device_id, Integer

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/"
    get_url = "/axapi/v3/device-context"
    device_id = new_resource.device_id

    params = { "device-context": {"device-id": device_id,} }

    params[:"device-context"].each do |k, v|
        if not v 
            params[:"device-context"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating device-context') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/device-context"
    device_id = new_resource.device_id

    params = { "device-context": {"device-id": device_id,} }

    params[:"device-context"].each do |k, v|
        if not v
            params[:"device-context"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["device-context"].each do |k, v|
        if v != params[:"device-context"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating device-context') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/device-context"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting device-context') do
            client.delete(url)
        end
    end
end