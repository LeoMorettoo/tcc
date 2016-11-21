class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  def cenario
    @nodes = Node.new
    @nodes = @nodes.get_variables_conditions(params['id'])
    render "index"
  end

  def conditions_sub_trees
    @nodes_sub_tree = Node.new
    @nodes_sub_tree = @nodes_sub_tree.get_conditions_sub_tree(params['variable'],params['condition'],params['id'])
    respond_to do |format|
        if @nodes_sub_tree
            format.json { render :json => @nodes_sub_tree, :status => 200 }
        end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def node_params
    params.require(:node).permit(:tree_id, :variable, :condition, :result, :level)
  end
end
