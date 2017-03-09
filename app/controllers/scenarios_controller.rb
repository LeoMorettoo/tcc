class ScenariosController < ApplicationController
  before_action :set_scenario, only: [:show, :edit, :update, :destroy]

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.where(user_id: current_user)
  end

  # GET /scenarios/1
  # GET /scenarios/1.json

  def show
    scenario = Scenario.find params[:id]
    node = Node.new
    @path_for_result = node.path_for_result_by_id(scenario.node_id)
  end

  # GET /scenarios/1/edit
  def edit
  end


  # POST /scenarios
  # POST /scenarios.json

  ## salvando sem id do usuario e do node


  def create
    @scenario = current_user.scenarios.build(scenario_params)
    respond_to do |format|
     if @scenario.save
       format.json { render :json => 1, :status => 200 }
     else
       format.json { render :json => 2, :status => 200 }
     end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario.destroy
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scenario_params
      params.require(:scenario).permit(:name, :node_id)
    end
end
