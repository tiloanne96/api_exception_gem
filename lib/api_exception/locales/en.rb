module ApiException
  module Locales
    module En
      def self.en_translations
        ApiException::Locales.base_dir.join("en")
      end

      def self.en_translation
        en_translations.join("en.yml").to_s
      end
    end
  end
end
