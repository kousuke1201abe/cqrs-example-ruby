# frozen_string_literal: true

require 'graphql'
require_relative 'base_object'

module Types
  class Customer < Types::BaseObject
    field :id, String, null: false
  end
end
