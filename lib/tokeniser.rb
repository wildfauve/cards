class String
  def integer?
    Integer(self)
    return true
  rescue ArgumentError
    return false
  end
end


class Tokeniser
  
  Date_Tokens = ["xmas"]
  Date_Replace = ["24.12"]
  
  def initialize(token_string, desc_test={:desc=>false})
    @token_string = token_string
    @desc_test = desc_test[:desc]
  end
  
  def build
    tokens = @token_string.split(" ")
    puts "build--> tokens #{tokens}"
    result = {:string => [], :date => [], :money => []}
    event_token = nil
    tokens.each do |t|
      type_test = test(t)
      puts "build--> Type testing #{t} #{type_test}"      
      token_test = type_test.first
      if event_token
        event_dealt_with = t.integer?
        result[:date] << Date.parse(event_token + "." + t)  if t.integer?  # deal with Xmas 2011
        event_token = nil
      end
      if !event_token || (event_token && !event_dealt_with)
        case token_test
          when :string
            result[:string] << t.scan(/[[:print:]]/).join  #only the printable characters
          when :date
            result[:date] << type_test[1]
          when :event
            result[:string] << t if @desc_test
            event_token = type_test[1]
          when :money
            result[:money] << type_test[1]
          else
            raise "Parse error: #{t}"
        end
      end
    end
    puts "Tokeniser: #{result.inspect}"
    return result
  end
  
  def test(token)
    begin
      if !token.scan(/\$/).empty? # checking for money 
        return [:money, Money.parse(token)]
      end
      d = Date.strptime(token, "%d.%m.%y")  # determine if date
      return [:string] if token.length < 6
      return [:date, d]
    rescue Exception => e
      # deal with string-based tokens
      if Date_Tokens.include?(token.downcase)
        return [:event, Date_Replace[Date_Tokens.index(token.downcase)]]  #is it actually an event token e.g. "Xmas 2011"
      end
      return [:string]  #then its a string
    end
    
  end
end

