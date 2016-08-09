if Rails.env.development?
  module Rails
    module Rack
      class Logger
        protected

        def started_request_message(request)
          values = [
            request.request_method,
            request.ip,
            Time.zone.now.to_default_s,
            request.filtered_path
          ]

          format("%-7s IP: %-15s |  %s\nURL:    \"%s\"", *values)
        end
      end
    end
  end
end
