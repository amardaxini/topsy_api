module TopsyApi
  module Insight
    class Author < Hashie::Mash
      def to_s
        "Topsy Author: #{name}, @#{nick}, #{topsy_author_url}"
      end
      
      def response
        self[:response]
      end
    end
  end  
end