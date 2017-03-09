json.array!(@scenarios) do |scenario|
  json.extract! scenario, :id, :name, :node_id
  json.url scenario_url(scenario, format: :json)
end
