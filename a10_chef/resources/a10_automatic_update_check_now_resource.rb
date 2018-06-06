resource_name :a10_automatic_update_check_now

property :a10_name, String, name_property: true
property :feature_name, ['app-fw']

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/automatic-update/"
    get_url = "/axapi/v3/automatic-update/check-now"
    feature_name = new_resource.feature_name

    params = { "check-now": {"feature-name": feature_name,} }

    params[:"check-now"].each do |k, v|
        if not v 
            params[:"check-now"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating check-now') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/automatic-update/check-now"
    feature_name = new_resource.feature_name

    params = { "check-now": {"feature-name": feature_name,} }

    params[:"check-now"].each do |k, v|
        if not v
            params[:"check-now"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["check-now"].each do |k, v|
        if v != params[:"check-now"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating check-now') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/automatic-update/check-now"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting check-now') do
            client.delete(url)
        end
    end
end