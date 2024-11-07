# frozen_string_literal: true

class CouponQueryService
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def query_by_customer_id(customer_id)
    statement = @db_conn.db.prepare("
      SELECT
        id,
        discount_amount,
        expires_at,
        coupon_invalidations.coupon_id as invalidations,
        coupon_redemptions.coupon_id as redemptions
      FROM coupons
      LEFT JOIN coupon_invalidations ON coupons.id = coupon_invalidations.coupon_id
      LEFT JOIN coupon_redemptions ON coupons.id = coupon_redemptions.coupon_id
      WHERE customer_id = ?
    ")
    rows = statement.execute(customer_id)

    rows.map do |row|
      {
        id: row['id'],
        name: row['name'],
        discount_amount: row['discount_amount'],
        expires_at: row['expires_at'],
        invalidated: !row['invalidations'].nil?,
        redeemed: !row['redemptions'].nil?
      }
    end
  end
end
