# frozen_string_literal: true

Granted = Data.define(
  :aggregate_id,
  :customer_id,
  :discount_amount,
  :expires_at,
  :granted_at
)

Invalidated = Data.define(
  :aggregate_id,
  :invalidated_at
)
