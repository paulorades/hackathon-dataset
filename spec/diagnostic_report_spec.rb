# DiagnosticReport Spec

server = YAML.load_file('fhir_server.yml')

def test_diagnostic_report(resource, server)

    RSpec.describe '#delete' do
        result = fhir_delete(server, resource)
        it {expect(result.code).to be >= 200}
        it {expect(result.code).to be <= 204}

    end

    RSpec.describe '#put' do

        begin
            result = fhir_put(server, resource)
        rescue => e
            puts e.inspect
        end

        it {expect(result.code).to eq 200}

    end

    RSpec.describe '#get' do

        result = fhir_get(server, resource)

        it {expect(result.code).to eq 200}

        # need to remove the metadata and other keys from the server version
        json = JSON.parse(result)

        # Update these to be absolute URLs rather than the relative URLs listed in the resource
        resource['performer']['reference'] = server[:url] + resource['performer']['reference']
        resource['subject']['reference'] = server[:url] + resource['subject']['reference']

        fhir_resource_compare(server, resource, json)

    end
end

Dir.glob("**/DiagnosticReport/*") do |f|
    resource = JSON.parse(File.read(f))
    puts "Testing resource: #{f}"
    test_diagnostic_report(resource, server)
end