# frozen_string_literal: true

require_relative '../../domain/model/promotion/promotion'

class ApplyPromotionCommand
  def initialize(repository)
    @repository = repository
  end

  def exec(customer_id, promotion_id)
    current = Time.now

    promotion = @repository.find(promotion_id)

    event = promotion.apply(customer_id, current)

    @repository.persist_event(event)

    event
  end
end
