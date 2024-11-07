# frozen_string_literal: true

require_relative '../../domain/model/promotion/promotion'

class PublishPromotionCommand
  def initialize(repository)
    @repository = repository
  end

  def exec(promotion_id)
    current = Time.now

    promotion = @repository.find(promotion_id)

    event = promotion.publish(current)

    @repository.persist_event(event)

    event
  end
end
