# frozen_string_literal: true

class Discount
  attr_reader :amount

  def initialize(amount)
    raise StandardError, 'discount acount should be over 1' if amount <= 1
    raise StandardError, 'discount acount should be under 100000' if amount > 100_000

    @amount = amount
  end
end
