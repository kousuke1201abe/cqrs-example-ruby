# frozen_string_literal: true

require 'graphql'
require_relative 'base_input_object'

module Types
  class PublishPromotionInput < Types::BaseInputObject
    argument :promotion_id, String, required: true
  end
end
