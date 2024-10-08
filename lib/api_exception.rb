module ApiException
  class << self
    def root
      Pathname.new(File.expand_path('../', __FILE__))
    end

    def setup
      yield self
    end
  end
end

require_relative 'api_exception/version'
require_relative 'api_exception/base_exception'

#translations
require_relative 'api_exception/locales'
require_relative 'api_exception/locales/en'
require_relative 'api_exception/locales/es'