# frozen_string_literal: true

Submitted = Data.define(
  :aggregate_id,
  :name,
  :discount_amount,
  :slot_remaining_amount,
  :submitted_at
)

Published = Data.define(
  :aggregate_id,
  :published_at
)

Applied = Data.define(
  :aggregate_id,
  :customer_id,
  :slot_remaining_amount,
  :applied_at
)

SlotModified = Data.define(
  :aggregate_id,
  :original_remaining_amount,
  :modified_remaining_amount,
  :modified_at,
)
