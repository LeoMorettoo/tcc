class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  #load_and_authorize_resource

  def permissao
    if !current_user.is_admin?
      flash[:notice] = 'Acesso negado'
      redirect_to trees_path
    end
  end

  def index
      permissao
      @users = User.all
  end

  # GET /trees/new
  def new
    permissao
    @user = User.new
  end

  # GET /trees/1/edit
  def edit
    set_user
  end

  def create
    permissao
    @user = User.new (user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Úsuario criado com sucesso.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1
  # PATCH/PUT /trees/1.json
  def update
    permissao
    set_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Úsuario atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
    permissao
    set_user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'Úsuario deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :cpf, :email, :password)
  end

end
