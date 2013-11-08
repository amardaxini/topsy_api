module TopsyApi
  class Configuration
    attr_accessor :api_key
    def initialize(api_key=nil)
      @api_key = api_key
    end
  end
  class << self
    attr_accessor :configuration
  end
  def self.configure
    self.configuration = Configuration.new
    yield(configuration) if block_given?
  end
end  