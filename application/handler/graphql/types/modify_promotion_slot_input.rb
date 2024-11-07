# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class ModifyPromotionSlotInput < Types::BaseInputObject
    argument :promotion_id, String, required: true
    argument :slot_remaining_amount, Integer, required: true
  end
end
