class Api::V1::AnalyticsController < ApplicationController
  def gps_landlord
    events = ProximityEvent.all

    total = events.count

    sectors = events.group(:sector).count.map do |sector, count|
      {
        sector: sector,
        visits: count
      }
    end

    render json: {
      total_proximity_visits: total,
      unique_tracked_sectors: sectors.size,
      sector_analytics: sectors,
      hourly_peaks: [],
      daily_peaks: []
    }
  end
end