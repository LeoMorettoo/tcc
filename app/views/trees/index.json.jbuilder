json.array!(@trees) do |tree|
  json.extract! tree, :id, :user_id, :name, :instances_numbers, :variable_numbers, :tree_size
  json.url tree_url(tree, format: :json)
end
