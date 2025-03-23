# frozen_string_literal: true

module Puppet
  module Exceptions
    # Exceptions trown when given request fails
    class GraphDBRequestFailError < StandardError
      attr_reader :message

      def initialize(message = '')
        super(message)
        @message = message
      end
    end
  end
end
