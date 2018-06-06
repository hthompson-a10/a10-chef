resource_name :a10_logging_disable_partition_name

property :a10_name, String, name_property: true
property :disable_partition_name, [true, false]
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/logging/"
    get_url = "/axapi/v3/logging/disable-partition-name"
    disable_partition_name = new_resource.disable_partition_name
    uuid = new_resource.uuid

    params = { "disable-partition-name": {"disable-partition-name": disable_partition_name,
        "uuid": uuid,} }

    params[:"disable-partition-name"].each do |k, v|
        if not v 
            params[:"disable-partition-name"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating disable-partition-name') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/logging/disable-partition-name"
    disable_partition_name = new_resource.disable_partition_name
    uuid = new_resource.uuid

    params = { "disable-partition-name": {"disable-partition-name": disable_partition_name,
        "uuid": uuid,} }

    params[:"disable-partition-name"].each do |k, v|
        if not v
            params[:"disable-partition-name"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["disable-partition-name"].each do |k, v|
        if v != params[:"disable-partition-name"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating disable-partition-name') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/logging/disable-partition-name"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting disable-partition-name') do
            client.delete(url)
        end
    end
end