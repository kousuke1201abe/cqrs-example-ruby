# frozen_string_literal: true

require 'graphql'
require_relative 'types/coupon'
require_relative 'types/promotion'
require_relative 'types/customer'

class QueryType < GraphQL::Schema::Object
  field :coupons, [Types::Coupon], null: false do
    argument :customer_id, String, required: true
  end
  field :promotions, [Types::Promotion], null: false
  field :customers, [Types::Customer], null: false

  def coupons(**args)
    context[:coupon_query_service].query_by_customer_id(args[:customer_id])
  end

  def promotions
    context[:promotion_query_service].query_all
  end

  def customers
    context[:customer_query_service].query_all
  end
end
