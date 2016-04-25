class Node < ActiveRecord::Base
	belongs_to :tree
	has_ancestry

	def get_arvore(file,start_search,end_search,variaveis,tree_id)
		nome_no = ''
		tree = Array.new
		self.tree_id = tree_id
		nivel = 0
		condicao = ''
		resultado = ''
		id = 0
		id_pai = 0	

		array =  IO.readlines(file)[start_search..end_search]
		array.each do |line|		
			nivel = line.count('|')
			nome_no = variaveis.select { |variavel| line.include? variavel }
			nome_no = nome_no.first.to_str
			condicao = line.partition(nome_no).last.strip
			resultado = condicao.index(':')
			resultado = !resultado.nil? ? condicao[resultado..-1] : false
			id += 1

			if nivel == 0
				id_pai = 'NULL'
				tree = tree.unshift({id: id, id_pai: id_pai ,nivel: nivel , nome_no: nome_no , condicao: condicao , resultado: resultado})
			elsif nivel == tree[0][:nivel]
				id_pai = tree[0][:id_pai]
				tree = tree.unshift({id: id, id_pai: id_pai ,nivel: nivel , nome_no: nome_no , condicao: condicao , resultado: resultado})
			elsif nivel > tree[0][:nivel]
				id_pai = tree[0][:id]
				tree = tree.unshift({id: id, id_pai: id_pai ,nivel: nivel , nome_no: nome_no , condicao: condicao , resultado: resultado})
			else
				id_pai = tree.select {|no| no[:nivel] == nivel}
				id_pai =  id_pai.first
				id_pai = id_pai[:id_pai]
				tree = tree.unshift({id: id, id_pai: id_pai ,nivel: nivel , nome_no: nome_no , condicao: condicao , resultado: resultado})
			end
		end
		return tree.reverse
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
