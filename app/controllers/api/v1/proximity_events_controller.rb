module Api
  module V1
    class ProximityEventsController < BaseController
      def bulk
        events = params[:events] || []

        events.each do |event|
          ProximityEvent.find_or_create_by(external_id: event[:external_id]) do |e|
            e.listing_id = event[:listing_id]
            e.listing_title = event[:listing_title]
            e.sector = event[:sector]
            e.city = event[:city]
            e.entered_radius_at = event[:entered_radius_at]
            e.event_day = event[:event_day]
            e.latitude = event[:latitude]
            e.longitude = event[:longitude]
            e.radius_meters = event[:radius_meters]
          end
        end

        render json: { status: "ok" }
      end
    end
  end
end