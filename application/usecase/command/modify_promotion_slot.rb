class ModifyPromotionSlotCommand
    def initialize(repository)
        @repository = repository
    end

    def exec(promotion_id, slot)
        current = Time.now

        promotion = @repository.find(promotion_id)

        event = promotion.modify_slot(slot, current)

        @repository.persist_event(event)

        event
    end
end