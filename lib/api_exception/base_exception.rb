require 'yaml'

module ApiException
  class BaseException < StandardError
    attr_reader :code, :message, :errors, :type, :error_type

    def initialize(error_type, errors, params, platform = "API")
      @default_language = :En
      error = error_code_map[error_type]
      @hash_message = error[:message]
      @params = params

      @error_type = error_type
      @errors = [*errors]
      @code = error[:code] if error
      @message = parse_message if error
      @errors.push(@message)
      @errors = @errors.flatten
      @type = platform
    end

    def parse_message
      @parsed_message = @hash_message

      if @params.present?
        @params.each do |k, v|
          param = @parsed_message["{{#{parse_key(k)}}}"] || @parsed_message["%{#{parse_key(k)}}"]
          @parsed_message[param.to_s] = (v.to_s || "nil") if param
        end
      end

      @parsed_message
    end

    private

    def error_code_map
      {
        TIMEOUT: { code: 1, message: find_translation([:timeout]) },
        RECORD_NOT_FOUND: { code: 2, message: find_translation([:record_not_found]) },
        INVALID_USER: { code: 3, message: find_translation([:invalid_user]) },
        REPEATED_USER: { code: 4, message: find_translation([:duplicated_emails]) },
        INVALID_STATUS_CHANGE: { code: 5, message: find_translation([:invalid_status_change]) },
        UNAUTHORIZED: { code: 6, message: find_translation([:unauthorized_user]) },
        INVALID_POLICY: { code: 7, message: find_translation([:invalid_policy]) },
        NOT_ALLOWED: { code: 8, message: find_translation([:standard_error]) },
        INVALID_UPDATE: { code: 9, message: find_translation([:cannot_update]) },
        BASE_ERROR: { code: 10, message: "" },
        NOT_UNIQUE_RECORD: { code: 11, message: find_translation([:not_unique_record]) },
        ACTION_NOT_PERMITTED: { code: 12, message: find_translation([:action_not_permitted]) },
        INVALID_FILE: { code: 13, message: find_translation([:invalid_file]) },
        UNSUPPORTED_FILE: { code: 14, message: find_translation([:unsupported_file]) },
        INVALID_PARAMS: { code: 15, message: find_translation([:invalid_params]) },
        UPDATE_CONFLICT: { code: 16, message: find_translation([:update_conflict]) },
        INVALID_DATE_RANGE: { code: 17, message: find_translation([:invalid_date_range]) },
        AUTHENTICATION_FAILURE: { code: 18, message: find_translation([:authentication_failure]) },
      }
    end

    def parse_key(key)
      if key.class == Integer
        ""
      else
        key.try(:to_s)
      end
    end

    def define_language
      language = find_language
      locales = ApiException::Locales

      case language
      when :En
        @translations = YAML.load_file(locales::En.en_translation).with_indifferent_access
      when :Es
        @translations = YAML.load_file(locales::Es.es_translation).with_indifferent_access
      else
        @translations = YAML.load_file(locales::En.en_translation).with_indifferent_access
      end
    end

    def find_translation(path)
      define_language if @translations.nil?
      language = find_language

      @translations.dig(*[language, :base_exceptions, path].flatten)
    end

    def find_language
      ($locale.nil?) ? @default_language : $locale
    end
  end
end

