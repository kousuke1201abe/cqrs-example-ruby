# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class GrantCouponInput < Types::BaseInputObject
    argument :customer_id, String, required: true
    argument :discount_amount, Integer, required: true
  end
end
