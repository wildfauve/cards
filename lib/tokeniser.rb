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
  
  def initialize(token_string)
    @token_string = token_string
  end
  
  def build()
    tokens = @token_string.split(" ")
    result = {:string => [], :date => [], :money => []}
    event_token = nil
    tokens.each do |t|
      type_test = test(t)
      token_test = type_test.first
      if event_token
        result[:date] << Date.parse(event_token + "." + t)  if t.integer?  # deal with Xmas 2011
        event_token = nil
      else
        case token_test
          when :string
            result[:string] << t.scan(/[[:print:]]/).join  #only the printable characters
          when :date
            result[:date] << type_test[1]
          when :event
            event_token = type_test[1]
          when :money
            result[:money] << type_test[1]
          else
            raise "Parse error: #{t}"
        end
      end
    end
    #puts "Tokeniser: #{result.inspect}"
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

