# frozen_string_literal: true

require_relative 'event'
require 'securerandom'

class Coupon
  attr_reader :id, :invalidated

  def self.grant(customer_id, discount, grant_at)
    expires_at = grant_at.years_since(1)

    Granted.new(SecureRandom.uuid, customer_id, discount.amount, expires_at, grant_at)
  end

  def invalidate(invalidate_at)
    raise StandardError, 'coupon has been already invalidated' if @invalidated

    Invalidated.new(@id, invalidate_at)
  end

  def initialize(id, invalidated)
    @id = id
    @invalidated = invalidated
  end
end
