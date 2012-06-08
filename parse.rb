require 'date'
require 'money'
require 'jbuilder'
require_relative 'lib/client'
require_relative 'lib/resource'
require_relative 'lib/card'
require_relative 'lib/buyer'
require_relative 'lib/tag'
require_relative 'lib/tokeniser'
require_relative 'lib/noise'

# ....., No Sale, N.C.?, N.C, N.Sale = NC, 
#
# TODO FORMAT of the Date in examples like 20.12.11 (what turns in 2020.12.11)
#

Card.set_connection = Resource::ResourceConnection.configure do
  @host =  "localhost:3000"
  @resource_entry = "/cards"
  @format = :json
end

Buyer.set_connection = Resource::ResourceConnection.configure do
  @host =  "localhost:3000"
  @resource_entry = "/customers"
  @format = :json
end

Tag.set_connection = Resource::ResourceConnection.configure do
  @host =  "localhost:3000"
  @resource_entry = "/tags"
  @format = :json
end


cards = []
#f = File.open('cards.csv', 'r')
f = File.open('small.csv', 'r')
f.each do |line|
  c = Card.new(line)
  cards << c.parse
end

# reverse them, and run the date_made calc to deal with cards with no date_made (which is Mandatory in MyCards).
rcards = cards.reverse
select_date = Date.today.strftime('%d.%m.%y')
rcards.each do |rc|
  if rc.date_made.nil?
    rc.date_made = select_date
  else
    select_date = rc.date_made.strftime('%d.%m.%y')
  end
end



cards.each do |c|
  puts "====IN LOOP"
  c.create_resource
end

