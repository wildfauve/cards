class Tag
  
  include Client
  
  class << self
    attr_accessor :resource_root, :connection, :search_term
  end
  
  self.resource_root = "tags"
  self.search_term = :tag
  
  
  attr_accessor :tag
  attr_reader :server_id

  @@tags = []
  
  def self.create(tag)
    puts "Tag is #{tag}"
    raise ArgumentError, "Tag can not be empty" if tag.empty?
    existing = @@tags.select {|t| t.tag.downcase == tag.downcase}
    if existing.empty?
      b = Tag.new(tag)
      @@tags << b
      return b
    else
      return existing[0]
    end
  end
  
  def self.set_connection=(connection)
    Tag.connection = connection
  end
  
  def initialize(tag)
    @tag = tag
    @server_id = nil
  end
  
  def create_resource
    result = create_or_find_resource(:search => true)
  end
  
  def json
    @representation = Jbuilder.encode do |j|
      j.token @tag
    end
  end
  
  
end