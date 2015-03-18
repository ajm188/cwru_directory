require 'spec_helper'

RSpec.describe CWRUDirectory::Configuration do
  before(:all) { @config = CWRUDirectory::Configuration.new }

end

RSpec.describe CWRUDirectory do
  describe '::configure' do
    before { CWRUDirectory.instance_variable_set(:@config, nil) }

    it 'sets the @config variable' do
      CWRUDirectory.configure
      config = CWRUDirectory.instance_variable_get(:@config)
      expect(config).to_not be nil
      expect(config.class).to eq CWRUDirectory::Configuration
    end

    it 'allows various config options to be set' do
      CWRUDirectory.configure do |config|
        config.case_id = 'abc123'
        config.password = 'password'
      end

      config = CWRUDirectory.instance_variable_get(:@config)
      expect(config.case_id).to eq 'abc123'
      expect(config.password).to eq 'password'
    end

    it 'does not overwrite the @config variable over multiple calls' do
      CWRUDirectory.configure do |config|
        config.case_id = 'abc123'
        config.password = 'password'
      end

      CWRUDirectory.configure do |config|
        config.password = 'mynewpassword'
      end

      new_config = CWRUDirectory.instance_variable_get(:@config)

      expect(new_config.case_id).to eq 'abc123'
      expect(new_config.password).to eq 'mynewpassword'
    end
  end
end
