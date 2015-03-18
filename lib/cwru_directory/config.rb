module CWRUDirectory
  class Configuration
    attr_accessor :case_id, :password
  end

  class << self
    def configure(&block)
      @config ||= Configuration.new
      yield @config if block_given?
    end
  end
end
