a10_client = A10Client::client_factory(host, port, protocol, username, password)

a10_cgnv6_one_to_one_global 'exampleName' do

    client a10_client
    action :create
end

a10_cgnv6_one_to_one_global 'exampleName' do

    client a10_client
    action :update
end

a10_cgnv6_one_to_one_global 'exampleName' do

    client a10_client
    action :delete
end