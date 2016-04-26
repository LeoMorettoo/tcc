class Node < ActiveRecord::Base
	belongs_to :tree
	has_ancestry

	def get_arvore(file,start_search,end_search,variaveis,tree_id)
		nome_no = ''
		tree = Array.new
		auxiliar_tree = Array.new
		nivel = 0
		condicao = ''
		resultado = ''
		id = 0
		identity = tree_id.to_s + '0'
		id_pai = identity + '1' 
		#ver porque ta indo errado a associacao dos nós 
		array =  IO.readlines(file)[start_search..end_search]
		array.each do |line|		
			node = self.class.new
			nivel = line.count('|')
			nome_no = variaveis.select { |variavel| line.include? variavel }
			nome_no = nome_no.first.to_str
			condicao = line.partition(nome_no).last.strip
			resultado = condicao.index(':')
			resultado = !resultado.nil? ? condicao[resultado..-1] : false
			id += 1 
			hash = {id: identity + id.to_s, tree_id: tree_id,id_pai: id_pai ,level: nivel , variable: nome_no , condition: condicao , result: resultado,created_at: Time.now, updated_at:Time.now}
			if nivel == 0
				auxiliar_tree = auxiliar_tree.unshift(hash)
				puts hash
				node = node.to_obj hash
			elsif nivel == auxiliar_tree[0][:level]
				id_pai = auxiliar_tree[0][:id_pai]
				auxiliar_tree = auxiliar_tree.unshift(hash)
				puts hash
				node = node.to_obj hash
				node.parent_id = id_pai
			elsif nivel > auxiliar_tree[0][:level]
				id_pai = auxiliar_tree[0][:id]
				auxiliar_tree = auxiliar_tree.unshift(hash)
				puts hash
				node = node.to_obj hash
				node.parent_id = id_pai
			else
				id_pai = auxiliar_tree.select {|no| no[:level] == nivel}
				id_pai =  id_pai.first
				id_pai = id_pai[:id_pai]
				auxiliar_tree = auxiliar_tree.unshift(hash)
				puts hash
				node = node.to_obj hash
				node.parent_id = id_pai
			end
			node.save
		end
		puts auxiliar_tree
	end

	def to_obj(hash)
		hash.except! :id_pai
		JSON.parse(hash.to_json, object_class: Node)
	end

	def get_variaveis(file,start_search,end_search)
		variaveis =[]
		array =  IO.readlines(file)[start_search..end_search]
		array.each do |variavel|
			variaveis << variavel.strip
		end
		return variaveis
	end
end
