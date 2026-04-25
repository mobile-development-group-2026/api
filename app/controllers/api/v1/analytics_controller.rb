# analytics_controller.rb
render json: {
  sector_analytics: sectors.map do |s|
    {
      id: s[:sector],
      sector: s[:sector],
      interest_level: interest_level(s[:visits]),
      unique_visitors: s[:visits],
      visit_count: s[:visits],
      average_daily_traffic: s[:visits].to_f
    }
  end,
  hourly_peaks: [],
  daily_peaks: [],
  total_visits: total,
  unique_sectors: sectors.size,
  last_synced_at: nil
}

private

def interest_level(count)
  return "Low" if count <= 2
  return "Medium" if count <= 9
  "High"
end