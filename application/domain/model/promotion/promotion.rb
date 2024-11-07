# frozen_string_literal: true

require_relative 'event'
require 'securerandom'

class Promotion
  attr_reader :id, :published, :slot, :applied_customer_ids

  def self.submit(name, discount, slot, submit_at)
    Submitted.new(SecureRandom.uuid, name.value, discount.amount, slot.remaining_amount, submit_at)
  end

  def publish(publish_at)
    raise StandardError, 'promotion is already published' if @published

    Published.new(@id, publish_at)
  end

  def apply(customer_id, apply_at)
    raise StandardError, 'promotion is not publishes' unless @published
    raise StandardError, 'slot is full' if @slot.is_full?
    raise StandardError, 'promotion has already been applied' if @applied_customer_ids.include?(customer_id)

    Applied.new(@id, customer_id, @slot.remaining_amount - 1, apply_at)
  end

  def modify_slot(slot, modify_at)
    raise StandardError, "remaining amount is same" if @slot.remaining_amount == slot.remaining_amount

    SlotModified.new(@id, @slot.remaining_amount, slot.remaining_amount, modify_at)
  end

  def initialize(id, published, slot, applied_customer_ids)
    @id = id
    @published = published
    @slot = slot
    @applied_customer_ids = applied_customer_ids
  end
end
