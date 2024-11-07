# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class SubmitPromotionInput < Types::BaseInputObject
    argument :name, String, required: true
    argument :discount_amount, Integer, required: true
    argument :slot_remaining_amount, Integer, required: true
  end
end
