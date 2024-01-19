module TeslaApi
  module Autopark
    def start_autopark(&handler)
      Async do |task|
        Async::WebSocket::Client.connect(autopark_endpoint, headers: headers) do |connection|
          while (message = connection.read)
            case message[:msg_type]
            when "control:hello"
              interval = message[:autopark][:heartbeat_frequency] / 1000.0
              task.async do |subtask|
                subtask.sleep interval
                connection.write({msg_type: "autopark:heartbeat_app", timestamp: Time.now.to_i}.to_json)
              end
            end

            handler.call(message)
          end
        end
      end
    end

    private

    def autopark_endpoint
      Async::HTTP::Endpoint.parse(autopark_endpoint_url)
    end

    def autopark_endpoint_url
      "wss://streaming.vn.teslamotors.com/connect/#{self["vehicle_id"]}"
    end

    def autopark_headers
      {
        "Authorization" => "Basic #{socket_auth}"
      }
    end

    def autopark_socket_auth
      Base64.strict_encode64("#{email}:#{self["tokens"].first}")
    end

    # Additional Error Handling
    def handle_auto_park error(error)
      
      puts "Autopark error: #{error.message}"
  end
  public


  #Main method for using the autopark endpoint
  def use_autopark
    begin
      #autopark Logic
    endpoint = autopark_endpoint
    headers = autopark_headers
    #Use the endpoint and headers for autopark functionality

    rescue StandardError => e
      handle_autopark_error(e)
    end
  end
end
