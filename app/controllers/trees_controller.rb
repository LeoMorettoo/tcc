class TreesController < ApplicationController
	before_action :set_tree, only: [:show, :edit, :update, :destroy]

  # GET /trees
  # GET /trees.json
  def index
  	@trees = Tree.all
  end

  # GET /trees/1
  # GET /trees/1.json
  def show
  end

  # GET /trees/new
  def new
  	@tree = Tree.new
  end

  # GET /trees/1/edit
  def edit
  end

  # POST /trees
  # POST /trees.json
  def create
  	@tree = Tree.new(tree_params)
  	upload
  	@tree.created_at = Time.now
  	@tree.name = @tree.file.original_filename
  	respond_to do |format|
  		if @tree.save  			
		  	nodes = Node.new
 	 		variaveis = nodes.get_variaveis(@nome_arquivo,@numero_da_linha[:numero_de_variaveis]+1,@numero_da_linha[:test_mode]-1)
 	 		nodes.get_arvore(@nome_arquivo,@numero_da_linha[:classifier_model]+5,@numero_da_linha[:numero_de_folhas]-2,variaveis,@tree.id)
			### adicionar a migracao que tira o autoincremt da buceta da tabela de nodes
			### adicionar um numero prefixo que não vá dar problema e resa muleke 
			i= 0 
  			format.html { redirect_to @tree, notice: 'Arquivo Adicionado com sucesso.' }
  			format.json { render :show, status: :created, location: @tree }
  		else
  			format.html { render :new }
  			format.json { render json: @tree.errors, status: :unprocessable_entity }
  		end
  	end
  end

##ler o arquivo de upload, salvar as metadatas da arvore.
## passar o array gerado e trabalhar nele no biblioteca ancestry e salvar. foda-se
def upload
	set_up_instances_variable
	uploaded_io = @tree.file
	@nome_arquivo = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
	File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
		file.write(uploaded_io.read)
	end
	ler_texto @nome_arquivo
end

  # PATCH/PUT /trees/1
  # PATCH/PUT /trees/1.json
  def update
  	respond_to do |format|
  		if @tree.update(tree_params)
  			format.html { redirect_to @tree, notice: 'Nome da arvore atualizado com sucesso.' }
  			format.json { render :show, status: :ok, location: @tree }
  		else
  			format.html { render :edit }
  			format.json { render json: @tree.errors, status: :unprocessable_entity }
  		end
  	end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
  	@tree.destroy
  	respond_to do |format|
  		format.html { redirect_to trees_url, notice: 'Arvore deletado com sucesso.' }
  		format.json { head :no_content }
  	end
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_tree
		@tree = Tree.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def tree_params
		params.require(:tree).permit(:user_id, :file)
	end

	def get_instancias(line)
		if !line.index(@variaveis_de_text[:instancias]).nil?
			teste_tamanho_variavel = @variaveis_de_text[:instancias].length
			@tree.instances_numbers = line[teste_tamanho_variavel ..-1].strip.to_i
			@variaveis_status[:intancias] = 1
			@numero_da_linha[:instancias] = @linha
		end 
	end

	def get_numero_de_variaveis(line)  
		if !line.index(@variaveis_de_text[:numero_de_variaveis]).nil?
			teste_tamanho_variavel = @variaveis_de_text[:numero_de_variaveis].length
			@tree.variable_numbers = line[teste_tamanho_variavel ..-1].strip.to_i 
			@variaveis_status[:numero_de_variaveis] = 1
			@numero_da_linha[:numero_de_variaveis] = @linha
		end 
	end

	def get_numero_de_folhas(line)
		if !line.index(@variaveis_de_text[:numero_de_folhas]).nil?
			teste_tamanho_variavel = @variaveis_de_text[:numero_de_folhas].length
			@tree.leaf_number = line[teste_tamanho_variavel ..-1].strip.to_i
			@status_numero_de_folhas = 1
			@variaveis_status[:numero_de_folhas] = 1
			@numero_da_linha[:numero_de_folhas] = @linha
		end
	end


	def get_tamanho_da_arvore(line)
		if !line.index(@variaveis_de_text[:tamanho_da_arvore]).nil? 
			teste_tamanho_variavel = @variaveis_de_text[:tamanho_da_arvore].length  
			@tree.tree_size = line[teste_tamanho_variavel ..-1].strip.to_i
			@status_tamanho_da_arvore = 1
			@variaveis_status[:tamanho_da_arvore] = 1
			@numero_da_linha[:tamanho_da_arvore] = @linha
		end
	end

	def get_test_mode(line)
		if !line.index(@variaveis_de_text[:test_mode]).nil? 
			teste_tamanho_variavel = @variaveis_de_text[:test_mode].length  
			@tamanho_da_arvore = line[teste_tamanho_variavel ..-1].strip.to_i
			@status_test_mode = 1
			@variaveis_status[:test_mode] = 1
			@numero_da_linha[:test_mode] = @linha
		end
	end

	def get_classifier_model(line)
		if !line.index(@variaveis_de_text[:classifier_model]).nil?  
			teste_tamanho_variavel = @variaveis_de_text[:classifier_model].length 
			@tamanho_da_arvore = line[teste_tamanho_variavel ..-1].strip.to_i
			@status_classifier_model = 1
			@variaveis_status[:classifier_model] = 1
			@numero_da_linha[:classifier_model] = @linha
		end
	end

	def ler_texto(nome_arquivo)
		File.foreach( nome_arquivo ) do |line|
			if @variaveis_status[:intancias] == 0
				get_instancias(line.to_str)
			end 

			if @variaveis_status[:numero_de_folhas] == 0
				get_numero_de_folhas(line.to_str)
			end

			if @variaveis_status[:tamanho_da_arvore] == 0
				get_tamanho_da_arvore(line.to_str)
			end

			if @variaveis_status[:numero_de_variaveis] == 0
				get_numero_de_variaveis(line.to_str)
			end   

			if @variaveis_status[:test_mode] == 0
				get_test_mode(line.to_str)
			end 

			if @variaveis_status[:classifier_model] == 0
				get_classifier_model(line.to_str)
			end 
			@linha += 1
		end
	end

	def set_up_instances_variable
		@nome_arquivo = ''

		@linha = 0

		@status_variaveis = 0
		@status_intancias = 0
		@status_numero_de_folhas = 0
		@status_tamanho_da_arvore = 0
		@status_numero_de_variaveis = 0
		@status_test_mode = 0
		@status_classifier_model = 0

		@variaveis_status = {
			instancias: 0,
			numero_de_folhas: 0,
			tamanho_da_arvore: 0,
			numero_de_variaveis: 0,
			test_mode: 0,
			classifier_model: 0
		}

		@variaveis_de_text = {
			instancias: 'Instances:',
			numero_de_folhas: 'Number of Leaves  :',
			tamanho_da_arvore: 'Size of the tree :',
			numero_de_variaveis: 'Attributes:',
			test_mode: 'Test mode:',
			classifier_model: '=== Classifier model'
		}

		@numero_da_linha = {
			instancias: @linha,
			numero_de_folhas: @linha,
			tamanho_da_arvore: @linha,
			numero_de_variaveis: @linha,
			test_mode: @linha,
			classifier_model: @linha
		}
	end

end
