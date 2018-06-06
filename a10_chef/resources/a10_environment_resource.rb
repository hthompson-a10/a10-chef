resource_name :a10_environment

property :a10_name, String, name_property: true
property :update_interval, Hash
property :threshold_cfg, Hash
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/"
    get_url = "/axapi/v3/environment"
    update_interval = new_resource.update_interval
    threshold_cfg = new_resource.threshold_cfg
    uuid = new_resource.uuid

    params = { "environment": {"update-interval": update_interval,
        "threshold-cfg": threshold_cfg,
        "uuid": uuid,} }

    params[:"environment"].each do |k, v|
        if not v 
            params[:"environment"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating environment') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/environment"
    update_interval = new_resource.update_interval
    threshold_cfg = new_resource.threshold_cfg
    uuid = new_resource.uuid

    params = { "environment": {"update-interval": update_interval,
        "threshold-cfg": threshold_cfg,
        "uuid": uuid,} }

    params[:"environment"].each do |k, v|
        if not v
            params[:"environment"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["environment"].each do |k, v|
        if v != params[:"environment"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating environment') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/environment"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting environment') do
            client.delete(url)
        end
    end
end