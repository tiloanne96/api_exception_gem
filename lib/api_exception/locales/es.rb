module ApiException
  module Locales
    module Es
      def self.en_translations
        ApiException::Locales.base_dir.join("es")
      end

      def self.en_translation
        en_translations.join("es.yml").to_s
      end
    end
  end
end
