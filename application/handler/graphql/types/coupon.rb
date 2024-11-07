# frozen_string_literal: true

require 'graphql'
require_relative 'base_object'

module Types
  class Coupon < Types::BaseObject
    field :id, String, null: false
    field :discount_amount, Integer, null: false
    field :expires_at, GraphQL::Types::ISO8601DateTime, null: false
    field :invalidated, Boolean, null: false
    field :redeemed, Boolean, null: false
  end
end
