module Kerala
  class Producer

    def initialize(conn_string = ENV["KERALA_KAFKA_CONNECTION"])
      @producer = Poseidon::Producer.new([conn_string], "kerala")
    end

    def send_message(topic, message)
      _message = Poseidon::MessageToSend.new(topic, message)
      producer.send_messages([_message])
    end

    private

    attr_reader :producer
  end
end
