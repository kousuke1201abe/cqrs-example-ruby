# frozen_string_literal: true

class Slot
  attr_reader :remaining_amount

  def initialize(remaining_amount)
    raise StandardError, 'Slot remaining amount should be over 0' if remaining_amount < 0
    raise StandardError, 'Slot remaining amount should be under 100000' if remaining_amount > 100_000

    @remaining_amount = remaining_amount
  end

  def is_full?
    @remaining_amount == 0
  end
end
