# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class ApplyPromotionInput < Types::BaseInputObject
    argument :customer_id, String, required: true
    argument :promotion_id, String, required: true
  end
end
