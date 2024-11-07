# frozen_string_literal: true

require_relative '../../domain/model/promotion/promotion'

class SubmitPromotionCommand
  def initialize(repository)
    @repository = repository
  end

  def exec(name, discount, slot)
    current = Time.now

    event = Promotion.submit(name, discount, slot, current)

    @repository.persist_event(event)

    event
  end
end
