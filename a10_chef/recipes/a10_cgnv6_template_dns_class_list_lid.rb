a10_client = A10Client::client_factory(host, port, protocol, username, password)

a10_cgnv6_template_dns_class_list_lid 'exampleName' do
    lidnum 1

    client a10_client
    action :create
end

a10_cgnv6_template_dns_class_list_lid 'exampleName' do
    lidnum 1

    client a10_client
    action :update
end

a10_cgnv6_template_dns_class_list_lid 'exampleName' do
    lidnum 1

    client a10_client
    action :delete
end