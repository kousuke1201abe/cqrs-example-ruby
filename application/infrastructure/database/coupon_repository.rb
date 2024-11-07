# frozen_string_literal: true

require_relative '../../domain/model/coupon/coupon'

class CouponRepository
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def persist_event(event)
    case event
    when Granted
      persist_granted(event)
    when Invalidated
      persist_invalidated(event)
    else
      raise 'invalid event'
    end
  end

  def find(id)
    statement = @db_conn.db.prepare('SELECT id FROM coupons WHERE id = ?')
    rows = statement.execute(id)
    coupon = rows.first

    statement = @db_conn.db.prepare('SELECT EXISTS( SELECT * FROM coupon_invalidations WHERE coupon_id = ?) AS exist')
    rows = statement.execute(id)
    coupon_invalidation = rows.first

    Coupon.new(coupon['id'], (coupon_invalidation['exist']).positive?)
  end

  private

  def persist_granted(event)
    statement = @db_conn.db.prepare('INSERT INTO coupons (id, customer_id, discount_amount, expires_at, granted_at) VALUES (?, ?, ?, ?, ?)')
    statement.execute(event.aggregate_id, event.customer_id, event.discount_amount, event.expires_at,
                      event.granted_at)
  end

  def persist_invalidated(event)
    statement = @db_conn.db.prepare('INSERT INTO coupon_invalidations (coupon_id, invalidated_at) VALUES (?, ?)')
    statement.execute(event.aggregate_id, event.invalidated_at)
  end
end
