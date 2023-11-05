module Services
  class BaseService
    attr_reader :errors

    def initialize(**kwargs)
      @errors = []
    end

    def log_error
      puts("Errors: #{error_message}")
    end

    private

    def successful?
      @errors.none?
    end

    def error_message
      @errors.join(', ')
    end

    def add_error(message)
      @errors << message
    end
  end
end
