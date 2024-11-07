require_relative '../../application/handler/graphql/schema'

File.write('api/graphql/schema.graphqls', Schema.to_definition)
