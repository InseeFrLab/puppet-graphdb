# frozen_string_literal: true

# This function java opts string from given array.
#
# @example generate_java_opts_string(['-Xmx1g','-Xms2g','-Dwell']) will return: "-Xmx1g -Xms2g -Dwell"

module Puppet::Parser::Functions
  newfunction(:generate_java_opts_string, type: :rvalue, doc: 'This function java opts string from given array.') do |arguments|
    raise(ArgumentError, 'generate_java_opts_string(): Wrong number of arguments ' \
      "given (#{arguments.size} for 1)") if arguments.empty?

    array = arguments[0]

    unless array.is_a?(Array)
      raise ArgumentError, "generate_java_opts_string(): expected argument to be an Array, got #{array.inspect}"
    end

    array[0...-1].map { |opt| opt.insert(-1, ' \\') }
    return array.join("\n").to_s
  end
end
