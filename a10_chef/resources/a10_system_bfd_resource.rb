resource_name :a10_system_bfd

property :a10_name, String, name_property: true
property :sampling_enable, Array
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/system/"
    get_url = "/axapi/v3/system/bfd"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "bfd": {"sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"bfd"].each do |k, v|
        if not v 
            params[:"bfd"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating bfd') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/system/bfd"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "bfd": {"sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"bfd"].each do |k, v|
        if not v
            params[:"bfd"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["bfd"].each do |k, v|
        if v != params[:"bfd"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating bfd') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/system/bfd"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting bfd') do
            client.delete(url)
        end
    end
end