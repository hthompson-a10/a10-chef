resource_name :a10_slb_dns_cache

property :a10_name, String, name_property: true
property :sampling_enable, Array
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/slb/"
    get_url = "/axapi/v3/slb/dns-cache"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "dns-cache": {"sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"dns-cache"].each do |k, v|
        if not v 
            params[:"dns-cache"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating dns-cache') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/slb/dns-cache"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid

    params = { "dns-cache": {"sampling-enable": sampling_enable,
        "uuid": uuid,} }

    params[:"dns-cache"].each do |k, v|
        if not v
            params[:"dns-cache"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["dns-cache"].each do |k, v|
        if v != params[:"dns-cache"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating dns-cache') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/slb/dns-cache"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting dns-cache') do
            client.delete(url)
        end
    end
end