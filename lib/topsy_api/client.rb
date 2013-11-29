require 'topsy_api/configuration'
module TopsyApi
  class Client
    
    @@connection = Faraday.new(:url => 'http://api.topsy.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    attr_accessor :api_key,:response,:mashie_response
    def get( path , opts = {} )
      if @api_key.length > 0 
        # Handle appending the api key
        opts[:query] = {} unless opts.has_key?(:query)
        opts[:query].merge!( { :apikey => @api_key } )
      end
      @response = @@connection.get( "/v2"+path , opts[:query] )
    end

    def initialize( options = {} )
      @api_key = TopsyApi.configuration.api_key
    end

    # Returns info about API rate limiting
    #
    # @return [Topsy::RateLimitInfo]
    def credit
      handle_response(get("/credit.json"))
    end
    
    # Provides a list of authors who mention the specified query term(s), 
    # sorted by frequency of tweets and the author’s influence level.
    # The response contains array of influencer
    #
    # @param [String] name
    #   Name of authors separated by comma
    # @return [Array<TopsyApi::Insight::Author>]
    def author_info(name)
       handle_response(get("/insights/author.json", :query => {:query => name}))
      
    end  
    #
    # @param [String] query
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #  @param [String] sort_by_options  optional
    #   sort_by_options value  is "relavance","retweets","tweets","influence","followers"
    #  @param [Hash] filter parameters
    #   http://api.topsy.com/doc/filter-parameters/
    # @return [Array]
    def influence(query=nil,sort_by_options=nil,filter_parameters={})
      influence_info = handle_response(get("insights/influencers.json", :query => {:q => query,:sort_by=>sort_by_options}))
    end

    # @param [String] query
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #  @param [String] sort_by_options  optional
    #   sort_by_options value  is "relavance","acceleration","total"
    #  @param [Hash] filter parameters
    #   http://api.topsy.com/doc/filter-parameters/
    # @return [Array<TopsyApi::Insight::RelatedTerm>]
    def related_terms(query=nil,sort_by_options=nil,filter_parameters={},include_metrics=false,include_tweet=false)
      handle_response(get("insights/relatedterms.json", :query => {:q => query,:sort_by=>sort_by_options}))
      
    end

    # Provides volume of tweet mentions over time for a list of keywords.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #  @param [Hash] slice  optional
    # {:min_time=>1369945301,:max_time=>1370031701,:slice=>3600}
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Integer] cumulative
    #   1 for enabling cumulative,metrics are cumulative from previous slice values.
    #  @param [Hash] filter parameters
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array<TopsyApi::Metric::Mention>]
    def mentions(query=nil,slice={},cumulative=0,filter_parameters={})
      # mention_info = handle_response(get("metrics/mentions.json", :query => {:q => query,slice,cumulative,filter_parameters}))
    end


    # Provides the top tweets for a list of terms and additional search parameters. 
    # The ranking is determined by the sort method.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #  @param [String] sort by  optional
    # "relavance","matching_mention","mention","exposure","influence","acceleration",
    #  "reach","date","-date"
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Hash] options optional 
    #   {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>''}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array]
    def tweets(query=nil,options={})
      handle_response(get("/content/tweets.json", :query => {:q => query}.merge(options)))
    end
    
    # Provides a large set of tweets that match the specified query and filter parameters. The maximum number of items returned per query is 20,000.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #  
    #  @param [Hash] options optional 
    #   {:include_enrichment_all"=>0,"sample"=>0}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array<TopsyApi::Metric::Mention>]
    def bulk_tweets(query=nil,options={})
      handle_response(get("/content/bulktweets.json", :query => {:q => query}.merge(options)))
    end

    def streaming(query,options={})
      handle_response(get("/content/bulktweets.json", :query => {:q => query}.merge(options)))
    end
    
    # Provides the top links for a list of terms and additional search parameters. The ranking is determined by the sort method.
    # The ranking is determined by the sort method.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Hash] options optional 
    #  sort_by
    # "relavance","matching_mention","mention","exposure","influence","acceleration",
    #  "reach","date","-date"
    #   {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>'',:new+only=>0}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array]
    def links(q=nil,options={})
      handle_response(get("/content/links.json", :query => {:q => query}.merge(options)))
    end
    # Provides the top photos for a list of terms and additional search parameters. The ranking is determined by the sort method.
    # The ranking is determined by the sort method.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Hash] options optional 
    #  sort_by
    # "relavance","matching_mention","mention","exposure","influence","acceleration",
    #  "reach","date","-date"
    #   {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>'',:new+only=>0}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array]
    def photos(q=nil,options={})
      handle_response(get("/content/photos.json", :query => {:q => query}.merge(options)))
    end
    # Provides the top videos for a list of terms and additional search parameters. The ranking is determined by the sort method.
    # The ranking is determined by the sort method.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Hash] options optional 
    #  sort_by
    # "relavance","matching_mention","mention","exposure","influence","acceleration",
    #  "reach","date","-date"
    #   {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>'',:new+only=>0}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array]
    def videos(q=nil,options={})
      handle_response(get("/content/videos.json", :query => {:q => query}.merge(options)))
    end
     # Provides the top videos for a list of terms and additional search parameters. The ranking is determined by the sort method.
    # The ranking is determined by the sort method.
    # @param [String] query  Query string optional
    #   Terms to find influencers for. If no term is entered, no influencers are returned.
    #   3600 if it is less than 1 day and greater than 1 hour, and 60 if it is less than 1 hour.
    #  @param [Hash] options optional 
    #  sort_by
    # "relavance","matching_mention","mention","exposure","influence","acceleration",
    #  "reach","date","-date"
    #   {"offset"=>1,"limit"=>1,"include_metrics"=>0,"include_enrichment_all"=>0,"new_only"=>0,:sort_by=>'',:new+only=>0}
    #   http://api.topsy.com/doc/filter-parameters/
    #  @return [Array]
    def citations(url=nil,options={})
      handle_response(get("/content/citations.json", :query => {:url => url}.merge(options)))
    end
    #
    def conversations(url)
      handle_response(get("/content/conversation.json", :query => {:url => url}))
    end

    # Returns true if a tweet is still valid, false otherwise. This is useful to check for tweet deletions that occur after a tweet was first returned.
    def tweet(postids)
      handle_response(get("/content/tweet.json", :query => {:postids => postids}))
    end
    #Returns true if a tweet is still valid, false otherwise. This is useful to check for tweet deletions that occur after a tweet was first returned.

    def validate(postids)
      handle_response(get("/content/validate.json", :query => {:postids => postids}))
    end
    # Provides a list of potential region integer IDs based on a search string.


    def location(location,types=nil)
      handle_response(get("/content/location.json", :query => {:location => location,:types=>types}))
    end
    private
    
      def handle_response(response)
        raise_errors(response)
        mashup(response)
      end

      def raise_errors(response)
        code = response.status.to_i
        case code
        when 400
          raise TopsyApi::General.new("Parameter check failed. This error indicates that a required parameter is missing or a parameter has a value that is out of bounds.")
        when 403
          raise TopsyApi::Unauthorized.new
        when 404
          raise TopsyApi::NotFound.new
        when 500
          raise TopsyApi::InformTopsy.new
        when 503
          raise TopsyApi::Unavailable.new
        end
      end

      def mashup(response)
        # @mashie_response = Hashie::Mash.new(JSON.parse(response.body))
        begin
            @mashie_response = (JSON.parse(response.body))
        rescue =>error
        end    
      end
      
      # extracts the header key
      def extract_header_value(response, key)
        response.headers[key].class == Array ? response.headers[key].first.to_i : response.headers[key].to_i 
      end
   

  end
end