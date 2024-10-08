module ApiException
  module Locales
    class << self
      def base_dir
        Pathname.new(File.expand_path("#{ApiException.root}/api_exception/locales/", __FILE__))
      end
    end
  end
end