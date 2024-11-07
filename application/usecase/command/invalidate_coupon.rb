# frozen_string_literal: true

class InvalidateCouponCommand
  def initialize(repository)
    @repository = repository
  end

  def exec(coupon_id)
    current = Time.now

    coupon = @repository.find(coupon_id)

    event = coupon.invalidate(current)

    @repository.persist_event(event)

    event
  end
end
