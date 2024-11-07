# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/modify_promotion_slot_input'
require_relative '../../../domain/model/promotion/slot'

module Mutations
  class ModifyPromotionSlot < Mutations::BaseMutation
    argument :input, Types::ModifyPromotionSlotInput, required: true

    field :promotion_id, String, null: false

    def resolve(input:)
      event = context[:modify_promotion_slot_command].exec(input[:promotion_id], Slot.new(input[:slot_remaining_amount]))

      { promotion_id: event.aggregate_id }
    rescue StandardError => e
      raise ::GraphQL::ExecutionError, e.message
    end
  end
end