json.array!(@nodes) do |node|
  json.extract! node, :id, :tree_id, :variable, :condition, :result, :level
  json.url node_url(node, format: :json)
end
