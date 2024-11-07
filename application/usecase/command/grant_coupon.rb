# frozen_string_literal: true

require_relative '../../domain/model/coupon/coupon'

class GrantCouponCommand
  def initialize(repository)
    @repository = repository
  end

  def exec(customer_id, discount)
    current = Time.now

    event = Coupon.grant(customer_id, discount, current)

    @repository.persist_event(event)

    event
  end
end
