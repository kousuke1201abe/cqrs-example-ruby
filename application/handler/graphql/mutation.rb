# frozen_string_literal: true

require 'graphql'
require_relative 'mutations/submit_promotion'
require_relative 'mutations/publish_promotion'
require_relative 'mutations/apply_promotion'
require_relative 'mutations/grant_coupon'
require_relative 'mutations/invalidate_coupon'
require_relative 'mutations/modify_promotion_slot' # この行を追加

class MutationType < GraphQL::Schema::Object
  field :submit_promotion, mutation: Mutations::SubmitPromotion
  field :publish_promotion, mutation: Mutations::PublishPromotion
  field :apply_promotion, mutation: Mutations::ApplyPromotion
  field :grant_coupon, mutation: Mutations::GrantCoupon
  field :invalidate_coupon, mutation: Mutations::InvalidateCoupon
  field :modify_promotion_slot, mutation: Mutations::ModifyPromotionSlot # この行を追加
end
