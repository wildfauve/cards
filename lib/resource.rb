require 'rest-client'

module Resource

  class ResourceConnection
    
    @@token = "admin"

    attr_accessor :host, :resource_entry, :format

    def url
      "#{host}#{resource_entry}.json"
    end

    def self.configure(&block)
      rc = ResourceConnection.new
      rc.instance_eval &block
      raise ArgumentError, "Missing Configuration" if rc.host.nil? || rc.resource_entry.nil? || rc.format.nil?
      raise ArgumentError, "Format Error" if rc.format != :json
      return rc
    end
  
    def get_resource(query)
      puts "In GET Resource: Query is: #{query}"
      JSON::parse(RestClient.get(self.url, query))
    end
  
    def create_resource(represent)
      body = represent.send @format
      puts "Resource Create: #{self.url}, #{body}"
      #{:id => 1}
      begin
        last_resp = RestClient.post(self.url, body, :content_type => @format, :accept => @format)
        if @format == :json
          puts "Status Code: #{last_resp.code}  Headers: #{last_resp.headers}"
          response = JSON::parse(last_resp)
          puts "Response Body: #{response}"
          #puts "Response Body: #{JSON::parse last_resp}"
          return response
        end
      rescue => e
        raise  IOError, "Server Exception Occured: #{e.response.code}"
      end
    end
    
  end
  
end