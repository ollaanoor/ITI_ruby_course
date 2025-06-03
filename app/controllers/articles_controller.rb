class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource except: [:create]

  # GET /articles or /articles.json
  def index
    # @articles = Article.all
    @articles = Article.where(archived: false)
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    # @article = Article.new(article_params)
    # @article.user = current_user 
    @article = current_user.articles.build(article_params)
    authorize! :create, @article
    @article.archived = false if @article.archived.nil?
    @article.reports_count = 0 if @article.reports_count.nil?

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def report
    @article = Article.find(params[:id])
  
    if current_user != @article.user
      @article.increment!(:reports_count)
      flash[:notice] = "Article reported."

      if (@article.reports_count || 0) >= 3 && !@article.archived?
        @article.update(archived: true)
      end
    end
  
    redirect_to articles_path
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:body, :image)
    end
end
