class Card
  
  include Client
    
  attr_reader :description, :colour, :buyer_tag, :date_sold, :cost, :no_charge, :date_made
  attr_accessor :server_id, :server_ref_id
  
  class << self
    attr_accessor :resource_root, :connection
  end
  
  @@id_counter = 1
  
  self.resource_root = ""
  
  Colour_swatch = ["black", "grey", "pink", "ivory", "gold", "blue", "white",
                  "green", "silver", "yellow", "red", "olive", "brown"]
  Tag_options = ["anniversary", "birthday", "butterfly", "cat", "flowers", "girl", "greetings", "kiwi",
                "material", "mount", "nz", "paper", "paua", "ribbon", "stamp", "sticker", "thankyou", "tiki",
                "waves", "window", "usa"]
  
  def self.set_connection=(connection)
    Card.connection = connection
  end
  
  def initialize(line)
    @line = line
    @id = @@id_counter
    @@id_counter += 1
    @tags = []
    @buyer_tags = []
  end

  def parse
    puts "=====> START NEW CARD"
    items = @line.split('|')
    items.fill("", items.length,6-items.length)
    self.description = items[0]
    self.colour = items[1]
    self.buyer_date = items[2]
    self.date_made = items[3]
    self.cost = items[4]
    puts "========>CARD CREATED"
    puts self
    return self
  end
  

  def to_s
    puts "Id: #{@id}  Server Id: #{server_id}  Ref_id: #{server_ref_id}"
    puts "Description: #{@description}"
    puts "tags: #{@tags}"
    puts "Buyer Tags: #{@buyer_tags.inspect} Date Purchased: #{@date_purchased}"
    puts "Date Made: #{@date_made}"
    puts "Cost: #{@cost} or No Charge: #{@no_charge}"
    puts "Date Sold: #{@date_sold}"
    puts "total Paid: #{@total_paid}"
  end


  def description=(item)
    tokens = Tokeniser.new(item)
    result = tokens.build
    self.add_tags = Noise.make_quiet(result[:string]) unless result[:string].empty?
    @description = result[:string].join(" ")
  end
  
  def colour=(item)
    tokens = Tokeniser.new(item)
    result = tokens.build
    self.add_tags = Noise.make_quiet(result[:string]) unless result[:string].empty?
  end
  
  def add_tags=(tagin)
    tagin.map! {|i| i.downcase}
    taglist = tagin.select {|word| Colour_swatch.include?(word)}
    taglist.concat(tagin.select {|word| Tag_options.include?(word)})
    tagclass = []
    taglist.each {|t| self.tags = Tag.create(t) }
  end
  
  def tags=(tagclass)
    @tags << tagclass if !@tags.include?(tagclass)
  end
  
  def cost=(item)
    # If the cost contains a money class, then we have a price, 
    # otherwise its assumed no charge if it contains anything else.
    tokens = Tokeniser.new(item)
    result = tokens.build
    puts "Cost: #{result}"
    if !result[:money].empty?
      @cost = result[:money].first
    else
      @no_charge = true
    end
  end
  
  def cost
    @no_charge ? nil : @cost.cents
  end
  
  def date_made=(item)
    item = "" if item.nil?
    puts "Date Made: #{item.class}"
    tokens = Tokeniser.new(item)
    result = tokens.build
    @date_made = result[:date].first
  end
  
  def buyer_date=(item)
    tokens = Tokeniser.new(item)
    result = tokens.build
    self.buyer_tag = Noise.make_quiet(result[:string]).join(" ")
    puts "Buyer Date: #{result}"
    @date_sold = result[:date].first
  end
    
  def buyer_tag=(buyer)
    @buyer_tags << Buyer.create(buyer) unless buyer.empty?
#    buyer.empty? ? @buyer_tag = nil : @buyer_tag = Buyer.create(buyer)
  end
  
  def buyer_tag_collection
    @buyer_tags.empty? ? nil : @buyer_tags.collect {|t| t.server_id}.join(",")
  end

  def tags_collection
    @tags.empty? ? nil : @tags.collect {|t| t.server_id}.join(",")
  end
  
  def create_resource
    @buyer_tags.each {|b| b.create_resource}
    @tags.each {|t| t.create_resource}
    result = create_or_find_resource(:search => false)  
    puts "Result: #{result}"
  end

  def json
    puts "===> In To JSON"
    @representation = Jbuilder.encode do |j|
      j.description @description
      j.date_made @date_made.to_s
      j.date_sold @date_sold.to_s if @date_sold
      j.cents_price self.cost
      j.no_charge @no_charge if @no_charge
      j.card_custs self.buyer_tag_collection if !@buyer_tags.empty?
      j.card_tags self.tags_collection if !@tags.empty?
    end  
  end
 
end
