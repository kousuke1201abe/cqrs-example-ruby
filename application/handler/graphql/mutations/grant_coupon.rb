# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/grant_coupon_input'
require_relative '../../../domain/model/coupon/discount'

module Mutations
  class GrantCoupon < Mutations::BaseMutation
    argument :input, Types::GrantCouponInput, required: true

    field :coupon_id, String, null: false

    def resolve(input:)
      event = context[:grant_coupon_command].exec(input[:customer_id], Discount.new(input[:discount_amount]))

      { coupon_id: event.aggregate_id }
    rescue StandardError => e
      raise ::GraphQL::ExecutionError, e.message
    end
  end
end
