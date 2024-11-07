# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/submit_promotion_input'
require_relative '../../../domain/model/promotion/name'
require_relative '../../../domain/model/promotion/discount'
require_relative '../../../domain/model/promotion/slot'

module Mutations
  class SubmitPromotion < Mutations::BaseMutation
    argument :input, Types::SubmitPromotionInput, required: true

    field :promotion_id, String, null: false

    def resolve(input:)
      event = context[:submit_promotion_command].exec(Name.new(input[:name]),
                                                      Discount.new(input[:discount_amount]), Slot.new(input[:slot_remaining_amount]))

      { promotion_id: event.aggregate_id }
    rescue StandardError => e
      raise ::GraphQL::ExecutionError, e.message
    end
  end
end
