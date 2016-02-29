module Api
  module V1
    class UsersController < ApplicationController
      before_action :check_token!

      def me
        render json: { authToken: request.headers['Authorization'].gsub('Bearer ', ''), role: current_user.role }
      end
    end
  end
end
