# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/apply_promotion_input'
require_relative '../../../domain/model/promotion/name'
require_relative '../../../domain/model/promotion/discount'

module Mutations
  class ApplyPromotion < Mutations::BaseMutation
    argument :input, Types::ApplyPromotionInput, required: true

    field :promotion_id, String, null: false

    def resolve(input:)
      event = context[:apply_promotion_command].exec(input[:customer_id], input[:promotion_id])

      { promotion_id: event.aggregate_id }
    rescue StandardError => e
      raise ::GraphQL::ExecutionError, e.message
    end
  end
end
