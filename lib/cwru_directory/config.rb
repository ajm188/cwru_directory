module CWRUDirectory
  class Configuration
    # Method missing gives us an attr_accessor for any attribute
    # we might need on the configuration object.
    # 
    # Currently the only config attributes that are used are:
    #   * case_id
    #   * password
    #   * get_all_info
    def method_missing(meth, *args, &block)
      meth_string = meth.to_s
      attr_name = (meth_string.end_with?('=') ? meth_string[0..-2] : meth_string).to_sym

      self.class.class_eval do
        attr_accessor attr_name
      end

      self.send(meth, *args, &block)
    end
  end

  class << self
    def configure(&block)
      @config ||= Configuration.new
      yield @config if block_given?
    end
  end
end
