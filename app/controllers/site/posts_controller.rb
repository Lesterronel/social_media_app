module Site
  class PostsController < SiteController
    skip_before_action :authenticate_user!, only: [:index, :show]
    before_action :set_post, only: %i[ show edit update destroy ]

    # GET /posts or /posts.json
    def index
      @posts = Post.all
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
      if @post.user_id != current_user.id
        redirect_to site_post_path(id: @post.id), alert: "Post is not from this user." 
      end
    end

    # POST /posts or /posts.json
    def create
      @post = Post.new(post_params)
      @post.user = current_user

      respond_to do |format|
        if @post.save
          format.html { redirect_to site_post_path(id: @post.id), notice: "Post was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /posts/1 or /posts/1.json
    def update
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to site_post_path(id: @post.id), notice: "Post was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /posts/1 or /posts/1.json
    def destroy
      @post.destroy!

      respond_to do |format|
        format.html { redirect_to site_posts_path, status: :see_other, notice: "Post was successfully destroyed." }
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