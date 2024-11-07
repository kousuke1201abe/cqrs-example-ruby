# frozen_string_literal: true

require 'cgi/escape'

class Name
  attr_reader :value

  def initialize(value)
    raise StandardError, 'name should not be nil' if value.nil?
    raise StandardError, 'name should not be blank' if value.blank?
    raise StandardError, 'name length should not be over 50' if value.length > 50

    @value = CGI.escapeHTML(value)
  end
end
