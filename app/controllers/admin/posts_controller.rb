module Admin
  class PostsController < AdminController
    before_action :set_post, only: %i[ show edit update destroy ]
    # Define allowed columns and directions for ordering
    ALLOWED_COLUMNS = ['email', 'name', 'content', 'publish_date', 'permalink']
    ALLOWED_DIRECTIONS = ['asc', 'desc']

    # GET /posts or /posts.json
    def index
      @has_records = Post.for_datatables.present?

      if params[:sort].present? && params[:direction].present?

        # Validate params[:sort] and params[:direction] against the allowed values
        sort_column = ALLOWED_COLUMNS.include?(params[:sort]) ? params[:sort] : 'user_name' # default to 'user_name' if invalid
        sort_direction = ALLOWED_DIRECTIONS.include?(params[:direction]) ? params[:direction] : 'asc' # default to 'asc' if invalid

        # Perform actions if both params exist
        @posts = Post.filter(
            params.slice(:search_string, :active, :featured, :email), 
            params[:order_by].presence
          ).for_datatables.filter_by_publish_date(params[:date_from], params[:date_to]).order_by_column(sort_column, sort_direction)
      else
        @posts = Post.filter(
            params.slice(:search_string, :active, :featured, :email), 
            params[:order_by].presence
          ).for_datatables.filter_by_publish_date(params[:date_from], params[:date_to]
        )
      end
    end

    # GET /posts/1 or /posts/1.json
    def show
      @post = Post.find_by(id: params[:id])
    end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts or /posts.json
    def create
      @post = Post.new(post_params)
      @post.user = current_user

      respond_to do |format|
        if @post.save
          format.html { redirect_to admin_post_path(id: @post.id), notice: "Post was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /posts/1 or /posts/1.json
    def update
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to admin_post_path(id: @post.id), notice: "Post was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /posts/1 or /posts/1.json
    def destroy
      @post.destroy!

      respond_to do |format|
        format.html { redirect_to admin_posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Post.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def post_params
        params.expect(
          post: [ :name, :content, :publish_date, :active, :featured, :boolean, :permalink ]
        ).each_value { |value| value.try(:strip!) }
      end
  end
end
