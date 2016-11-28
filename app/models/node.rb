class Node < ActiveRecord::Base
    belongs_to :tree
    has_ancestry


    def get_variables_conditions(tree_id)
        variable = {}
        nodes = self.class.where(tree_id: tree_id)
        nodes.each { |node|
            name = node.variable.to_sym
            if !variable.key? name
                variable[name] =  Array.new()
            end
            node_obj = OpenStruct.new({name: node.condition})
            if !variable[name].detect {|node| node.name == node_obj.name}
                variable[name] << node_obj
            end
        }
        return variable
    end

    def get_conditions_sub_tree(variable,condition,id)
        array_node = Array.new
        if id.to_i == 0
            nodes = self.class.where(variable: variable, condition: condition)
        else
            nodes = self.class.where(id: id)
        end

        nodes.each do |node|
            array_node << node.descendants
        end
        return array_node
    end

    def path_for_result(result)
        paths = Array.new()
        nodes = self.class.where(result: result)
        nodes.each { |node|
            a = Array.new()
            node.path.each { |node|
                a << OpenStruct.new({variable: node.variable,condition: node.condition})
            }
            a = self.path_for_result_to_text a
            paths << a
        }
        return paths
    end

    def path_for_result_to_text(paths)
        text = ''
        paths.each_with_index do |node, index|
          text << "<p>#{index + 1}º - #{node.variable} #{node.condition}</p>"
        end
        return text
    end

    def extract_tree(file,start_search,end_search,variaveis,tree_id)
        nome_no = ''
        tree = Array.new
        auxiliar_tree = Array.new
        nivel = 0
        condicao = ''
        resultado = ''
        id = 0
        identity = tree_id.to_s + '0'
        id_pai = identity + '1'
        array =  IO.readlines(file)[start_search..end_search]
        array.each do |line|
            node = self.class.new
            nivel = line.count('|')
            nome_no = variaveis.select { |variavel| line.include? variavel }
            nome_no = nome_no.first.to_str
            condicao = line.partition(nome_no).last.strip
            no_resultado = condicao.index(':')
            resultado = false
            if !no_resultado.nil?
                resultado = condicao[no_resultado + 1.. - 1]
                resultado.strip!
                no_resultado_numero = resultado.index('(')
                resultado_numero = resultado[no_resultado_numero .. -1]
                resultado = resultado[0 .. no_resultado_numero -1]
                resultado.strip!
                resultado_numero.strip!
                condicao = condicao[0 .. no_resultado - 1 ]
            end
            condicao.strip!
            id += 1
            hash = {
                id: identity + id.to_s,
                tree_id: tree_id,
                id_pai: id_pai ,
                level: nivel ,
                variable: nome_no.parameterize.underscore ,
                condition: condicao ,
                result: resultado,
                result_numbers: resultado_numero,
                created_at: Time.now,
                updated_at:Time.now
            }
            if nivel == 0
                auxiliar_tree = auxiliar_tree.unshift(hash)
                node = node.to_obj hash
            elsif nivel > auxiliar_tree[0][:level]
                id_pai = auxiliar_tree[0][:id]
                auxiliar_tree = auxiliar_tree.unshift(hash)
                node = node.to_obj hash
                node.parent_id = id_pai
            else
                id_pai = auxiliar_tree.select {|no| no[:level] == nivel-1}
                id_pai =  id_pai.first
                id_pai = id_pai[:id]
                auxiliar_tree = auxiliar_tree.unshift(hash)
                node = node.to_obj hash
                node.parent_id = id_pai
            end
            node.save
        end
    end

    def to_obj(hash)
        hash.except! :id_pai
        JSON.parse(
            hash.to_json,
            object_class: Node
            )
    end

    def extract_variables(file,start_search,end_search)
        variaveis =[]
        array =  IO.readlines(file)[start_search..end_search]
        array.each do |variavel|
            variaveis << variavel.strip
        end
        return variaveis
    end
end
