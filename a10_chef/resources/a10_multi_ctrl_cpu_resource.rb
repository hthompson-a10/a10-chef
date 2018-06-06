resource_name :a10_multi_ctrl_cpu

property :a10_name, String, name_property: true
property :num_ctrl_cpus, Integer

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/"
    get_url = "/axapi/v3/multi-ctrl-cpu"
    num_ctrl_cpus = new_resource.num_ctrl_cpus

    params = { "multi-ctrl-cpu": {"num-ctrl-cpus": num_ctrl_cpus,} }

    params[:"multi-ctrl-cpu"].each do |k, v|
        if not v 
            params[:"multi-ctrl-cpu"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating multi-ctrl-cpu') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/multi-ctrl-cpu"
    num_ctrl_cpus = new_resource.num_ctrl_cpus

    params = { "multi-ctrl-cpu": {"num-ctrl-cpus": num_ctrl_cpus,} }

    params[:"multi-ctrl-cpu"].each do |k, v|
        if not v
            params[:"multi-ctrl-cpu"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["multi-ctrl-cpu"].each do |k, v|
        if v != params[:"multi-ctrl-cpu"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating multi-ctrl-cpu') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/multi-ctrl-cpu"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting multi-ctrl-cpu') do
            client.delete(url)
        end
    end
end