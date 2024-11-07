# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'graphql/playground'
require 'rack/contrib'
require 'mysql2'
require_relative '../../application/handler/graphql/schema'
require_relative '../../application/usecase/command/submit_promotion'
require_relative '../../application/usecase/command/publish_promotion'
require_relative '../../application/usecase/command/apply_promotion'
require_relative '../../application/usecase/command/grant_coupon'
require_relative '../../application/usecase/command/invalidate_coupon'
require_relative '../../application/usecase/command/modify_promotion_slot'
require_relative '../../application/infrastructure/database/db_conn'
require_relative '../../application/infrastructure/database/promotion_repository'
require_relative '../../application/infrastructure/database/coupon_repository'
require_relative '../../application/infrastructure/database/coupon_query_service'
require_relative '../../application/infrastructure/database/promotion_query_service'
require_relative '../../application/infrastructure/database/customer_query_service'

set :bind, '0.0.0.0'
set :port, 3000
configure do
  disable :logging
end

use Rack::PostBodyContentTypeParser

db_conn = DBConn.new

promotion_repository = PromotionRepository.new(db_conn)
coupon_repository = CouponRepository.new(db_conn)

submit_promotion_command = SubmitPromotionCommand.new(promotion_repository)
publish_promotion_command = PublishPromotionCommand.new(promotion_repository)
apply_promotion_command = ApplyPromotionCommand.new(promotion_repository)
grant_coupon_command = GrantCouponCommand.new(coupon_repository)
invalidate_coupon_command = InvalidateCouponCommand.new(coupon_repository)
modify_promotion_slot_command = ModifyPromotionSlotCommand.new(promotion_repository)

coupon_query_service = CouponQueryService.new(db_conn)
promotion_query_service = PromotionQueryService.new(db_conn)
customer_query_service = CustomerQueryService.new(db_conn)

post '/' do
  result = Schema.execute(
    params[:query],
    variables: ensure_hash(params[:variables]),
    context: {
      submit_promotion_command:,
      publish_promotion_command:,
      apply_promotion_command:,
      grant_coupon_command:,
      invalidate_coupon_command:,
      coupon_query_service:,
      promotion_query_service:,
      customer_query_service:
      modify_promotion_slot_command:,
    }
  )
  json result
end

get '/playground' do
  content_type 'text/html'
  <<-HTML
	<!DOCTYPE html>
	<html>
	  <head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>GraphQL Playground</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/graphql-playground-react/build/static/css/index.css" />
		<link rel="shortcut icon" href="https://cdn.jsdelivr.net/npm/graphql-playground-react/build/favicon.png" />
		<script src="https://cdn.jsdelivr.net/npm/graphql-playground-react/build/static/js/middleware.js"></script>
	  </head>
	  <body>
		<div id="root"></div>
		<script>
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.removedNodes.length) {
            mutation.removedNodes.forEach((node) => {
              if (
                node.tagName === "UL" &&
                node.classList.contains("CodeMirror-hints")
              ) {
                if (!node.parentElement && mutation.target.parentElement) {
                  mutation.target.parentElement.removeChild(mutation.target);
                }
              }
            });
          }
        });
      });
      observer.observe(document.body, {
        subtree: true,
        childList: true,
      });
		  window.addEventListener('load', function () {
			GraphQLPlayground.init(document.getElementById('root'), {
			  endpoint: '/',
			})
		  })
		</script>
	  </body>
	</html>
  HTML
end

def ensure_hash(ambiguous_param)
  case ambiguous_param
  when String
    ambiguous_param.strip.empty? ? {} : JSON.parse(ambiguous_param)
  when Hash
    ambiguous_param
  when nil
    {}
  else
    raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
  end
end
