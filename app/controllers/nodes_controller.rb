class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  def cenario
    @id = params['tree_id']
    @nodes = Node.new
    @nodes = @nodes.get_variables_conditions(params['tree_id'])
    render "index"
  end

  def cenario_resultado
    @id = params['tree_id']
    @results = Array.new
    nodes = Node.where("tree_id = #{params['tree_id']} AND result <> 'f'")
    nodes.each { |node|
      @results << node.result
    }
    @results = @results.uniq
    render "cenario_resultado"
  end

  #fazer um if caso o primeiro click seja o final precisa trazer o result e o id dele
  #verificar o bug de nao funcionar caso seja um array de arrays
  #colocar o campo text para o nome
  #embelezar o show dos cenarios
  def conditions_sub_trees
    @nodes_sub_tree = Node.new
    @nodes_sub_tree = @nodes_sub_tree.get_conditions_sub_tree(params['variable'],params['condition'],params['tree_id_condition'])
    respond_to do |format|
        if @nodes_sub_tree
            format.json { render :json => @nodes_sub_tree, :status => 200 }
        end
    end
  end

  def path_for_result
    node = Node.new
    @path_for_result = node.path_for_result(params['result'])
    respond_to do |format|
      if @path_for_result
          format.json { render :json => @path_for_result, :status => 200 }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def node_params
    params.require(:node).permit(:tree_id, :variable, :condition, :result, :level)
  end
end
