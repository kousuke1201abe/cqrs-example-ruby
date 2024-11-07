# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/invalidate_coupon_input'

module Mutations
  class InvalidateCoupon < Mutations::BaseMutation
    argument :input, Types::InvalidateCouponInput, required: true

    field :coupon_id, String, null: false

    def resolve(input:)
      event = context[:invalidate_coupon_command].exec(input[:coupon_id])

      { coupon_id: event.aggregate_id }
    rescue StandardError => e
      raise ::GraphQL::ExecutionError, e.message
    end
  end
end
