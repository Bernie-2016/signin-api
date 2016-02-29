module Api
  module V1
    class SignupsController < ApplicationController
      def create
        signup_params = params[:signups].first.last
        signup_params[:can_text] = (signup_params[:canText] == 'true') ? 'Yes' : 'No'
        signup_params[:event_id] ||= Event.default.id
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
