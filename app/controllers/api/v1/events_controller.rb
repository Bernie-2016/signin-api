module Api
  module V1
    class EventsController < ApplicationController
      before_action :check_token!, except: [:slug]

      def index
        scoped_events =
          if current_user.admin?
            Event.all
          else
            current_user.events
          end
        render json: scoped_events
      end

      def show
        authorize! :read, current_event
        render json: current_event
      end

      def slug
        render json: Event.where('lower(slug) = ?', params[:event_id].downcase).first
      end

      def csv
        authorize! :read, current_event
        send_data to_csv(current_event), filename: 'signups.csv'
      end

      def create
        event = Event.new(event_params)
        event.user = current_user
        if event.save
          render json: event, status: 200
        else
          render json: event.errors, status: 422
        end
      end

      def update
        authorize! :update, current_event
        current_ids = current_event.questions.pluck(:id)
        if current_event.update(event_params)
          included_ids = (event_params['questions_attributes'] || {}).map { |_, v| v['id'] }
          current_event.questions.where(id: current_ids).where.not(id: included_ids).destroy_all
          render json: current_event, status: 200
        else
          render json: current_event.errors, status: 422
        end
      end

      def destroy
        authorize! :destroy, current_event
        current_event.destroy
        head :no_content
      end

      private

      def event_params
        params.require(:event).permit(:name, :date, :slug, questions_attributes: [:id, :title, :type])
      end

      def current_event
        @current_event ||= Event.find(params[:id] || params[:event_id])
      end

      def to_csv(event)
        columns = %w(timestamp event first_name last_name email phone zip can_text)
        event.questions.each { |q| columns << q.title }

        CSV.generate do |csv|
          csv << columns
          event.signups.each do |signup|
            row = []
            row << signup.created_at
            row << signup.event.name
            row << signup.first_name
            row << signup.last_name
            row << signup.email
            row << signup.phone
            row << signup.zip
            row << signup.can_text

            event.questions.each do |q|
              row << signup.answer(q)
            end

            csv << row
          end
        end
      end
    end
  end
end
