# frozen_string_literal: true

class PromotionQueryService
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def query_all
    rows = @db_conn.db.prepare("
      SELECT
        id,
        name,
        discount_amount,
        slot_remaining_amount,
        count(promotion_applications.customer_id) as applied_customer_number,
        promotion_publications.promotion_id AS promotion_publication_promotion_id
      FROM promotions
      LEFT JOIN promotion_applications ON promotions.id = promotion_applications.promotion_id
      LEFT JOIN promotion_publications ON promotions.id = promotion_publications.promotion_id
      GROUP BY promotions.id
    ").execute

    rows.map do |row|
      {
        id: row['id'],
        name: row['name'],
        discount_amount: row['discount_amount'],
        slot_remaining_amount: row['slot_remaining_amount'],
        applied_customer_number: row['applied_customer_number'],
        published: !row['promotion_publication_promotion_id'].nil?
      }
    end
  end
end
