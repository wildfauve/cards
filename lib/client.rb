module Client

  def class_name
    self.class
  end

  def create_or_find_resource(args)
    puts "CREATING #{class_name} "
    connection = class_name.connection
    if args[:search]
      if !@server_id                      # dont have an ID yet 
        server_res = resource_on_server # get the possible server resource
        if !server_res                  # check that it isn't already on the server
          resp = connection.create_resource(self)
          @server_id = resp["id"]
        else
          @server_id = server_res[0]["id"]  # set server id
        end
      end
    else
      response = connection.create_resource(self)  
    end
    puts "After Create resource ==> #{self.inspect}"
    return response
  end
  
  def resource_on_server
    search_term = self.send(class_name.search_term)
    response = class_name.connection.get_resource({:params => {:search => search_term.downcase}})
    puts "Resource Search ==> #{response}"
    response[class_name.resource_root].empty? ? false : response[class_name.resource_root]
  end

end