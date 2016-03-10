module Api
  module V1
    class SignupsController < ApplicationController
      def create
        signup_params = params[:signups].values.first
        signup_params.stringify_keys!
        if signup_params['extra_fields']
          begin
            signup_params['extra_fields'] = JSON.parse(signup_params['extra_fields'].gsub(/([a-zA-Z_]+):/, '"\1":')).first
          rescue JSON::ParserError
            render json: { erros: 'extra fields invalid' }, status: 422
          end
          signup_params['extra_fields'] = signup_params['extra_fields'].first if signup_params['extra_fields'].is_a?(Array)
          signup_params['event_id'] = signup_params['extra_fields']['event_id']
        end
        signup_params['can_text'] = (signup_params['canText'] || signup_params['can_text'] == 'true') ? 'Yes' : 'No'
        signup_params['event_id'] ||= Event.default.id
        render(nothing: true, status: 200) if Signup.exists?(event_id: signup_params['event_id'], email: signup_params['email'])
        signup_params.reject! { |param, _| permitted_params.exclude? param.intern }
        signup = Signup.new ActiveSupport::HashWithIndifferentAccess.new(signup_params)
        if signup.save
          PostBsdSignupWorker.perform_async(signup.id)
        else
          render json: signup.errors, status: 422
        end
      end

      private

      def permitted_params
        %i(first_name last_name email phone zip can_text event_id extra_fields)
      end
    end
  end
end
