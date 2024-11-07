# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class InvalidateCouponInput < Types::BaseInputObject
    argument :coupon_id, String, required: true
  end
end
