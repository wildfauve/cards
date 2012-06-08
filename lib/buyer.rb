class Buyer
  
  include Client
  
  attr_accessor :buyer
  attr_reader :server_id

  @@tags = []
    
  class << self
    attr_accessor :resource_root, :connection, :search_term
  end
  
  self.resource_root = "customers"
  self.search_term = :buyer
    
  def self.create(buyer)
    raise ArgumentError, "Buyer can not be empty" if buyer.empty?
    existing = @@tags.select {|tag| tag.buyer.downcase == buyer.downcase}
    if existing.empty?
      b = Buyer.new(buyer)
      @@tags << b
      #puts "Buyer: #{b.inspect} #{@@tags}"
      return b
    else
      #puts "existing #{existing.inspect} #{@@tags}"
      return existing[0]
    end
  end
  
  def self.set_connection=(connection)
    Buyer.connection = connection
  end
  
  def initialize(buyer)
    @buyer = buyer
    @server_id = nil
  end
  
  def create_resource
    result = create_or_find_resource(:search => true)
  end
  
  def json
    @representation = Jbuilder.encode do |j|
      j.name @buyer
    end
  end
  
  
end