# frozen_string_literal: true

require 'graphql'
require_relative 'base_argument'

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
end
