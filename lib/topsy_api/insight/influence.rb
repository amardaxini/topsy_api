module TopsyApi
  module Insight
    class Influence  < Hashie::Mash
      SORT_BY_OPTIONS =["relavance","retweets","tweets","influence","followers"]
      def response
        self[:response]
      end
      #  Pass hash or array of results based on that create influence and return array of influence
      def self.get_influence_info(author_infos)
        
      end

    end
  end
end