# frozen_string_literal: true

require_relative '../../domain/model/promotion/event'
require_relative '../../domain/model/promotion/promotion'

class PromotionRepository
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def persist_event(event)
    case event
    when Submitted
      persist_submitted(event)
    when Published
      persist_published(event)
    when Applied
      persist_applied(event)
    when SlotModified
      persist_slot_modified(event)
    else
      raise 'invalid event'
    end
  end

  def find(id)
    statement = @db_conn.db.prepare('
      SELECT id, slot_remaining_amount, promotion_publications.promotion_id AS "promotion_publication_promotion_id"
      FROM promotions
      LEFT JOIN promotion_publications ON promotions.id = promotion_publications.promotion_id
      WHERE id = ?
    ')
    promotion_row = statement.execute(id).first

    statement = @db_conn.db.prepare('
      SELECT id
      FROM customers
      LEFT JOIN promotion_applications ON promotion_applications.customer_id = customers.id
      WHERE promotion_applications.promotion_id = ?
    ')
    customer_rows = statement.execute(id)

    Promotion.new(promotion_row['id'], !promotion_row['promotion_publication_promotion_id'].nil?, Slot.new(promotion_row['slot_remaining_amount']), customer_rows.map do |row|
      row['id']
    end)
  end

  private

  def persist_slot_modified(event)
    statement = @db_conn.db.prepare('UPDATE promotions SET slot_remaining_amount = ?, modified_at = ? where id = ? AND slot_remaining_amount = ?')
    statement.execute(event.modified_remaining_amount, event.modified_at, event.aggregate_id, event.original_remaining_amount)
    raise StandardError "concurrency problem occured", if @db_conn.db.affected_rows == 0
  end

  def persist_submitted(event)
    statement = @db_conn.db.prepare('INSERT INTO promotions (id, name, discount_amount, slot_remaining_amount, submitted_at, modified_at) VALUES (?, ?, ?, ?, ?, ?)')
    statement.execute(event.aggregate_id, event.name, event.discount_amount, event.slot_remaining_amount, event.submitted_at,
                      event.submitted_at)
  end

  def persist_published(event)
    statement = @db_conn.db.prepare('INSERT INTO promotion_publications (promotion_id, published_at) VALUES (?, ?)')
    statement.execute(event.aggregate_id, event.published_at)
  end

  def persist_applied(event)
    @db_conn.transaction do
      statement = @db_conn.db.prepare('UPDATE promotions SET slot_remaining_amount = ? where id = ? AND slot_remaining_amount = ?')
      statement.execute(event.slot_remaining_amount, event.aggregate_id, event.slot_remaining_amount + 1)

      statement = @db_conn.db.prepare('INSERT INTO promotion_applications (promotion_id, customer_id, applied_at) VALUES (?, ?, ?)')
      statement.execute(event.aggregate_id, event.customer_id, event.applied_at)
    end
  end
end
