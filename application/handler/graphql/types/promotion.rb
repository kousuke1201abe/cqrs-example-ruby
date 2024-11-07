# frozen_string_literal: true

require 'graphql'
require_relative 'base_object'

module Types
  class Promotion < Types::BaseObject
    field :id, String, null: false
    field :name, String, null: false
    field :discount_amount, Integer, null: false
    field :slot_remaining_amount, Integer, null: false
    field :published, Boolean, null: false
    field :applied_customer_number, Integer, null: false
  end
end
