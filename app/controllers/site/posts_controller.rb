module Site
  class PostsController < SiteController
    skip_before_action :authenticate_user!, only: [:index, :show, :content_full]
    before_action :set_post, only: %i[ show edit update destroy like ]

    # GET /posts or /posts.json
    def index
      @posts = Post.all.order(publish_date: :desc)
    end

    def like 
      if current_user.liked? @post
        @post.unliked_by current_user
      else
        @post.liked_by current_user
      end
      
      respond_to do |format|
        format.html do
          redirect_to site_post_path
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@post, 
                                partial: "post",
                                locals: {post: @post}
                              )
          ]
        end
      end
    end

    def content_full
      # debugger
      @post = Post.find_by(id: params[:id])
      render partial: "content_full", locals: { post: @post }
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
        redirect_to site_posts_path, alert: "Post is not from this user." 
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update(@post, 
                                  partial: "form",
                                  locals: {post: @post}
                                )
            ]
          end
        end
      end
    end

    # POST /posts or /posts.json
    def create
      @post = Post.new(post_params)
      @post.user = current_user

      respond_to do |format|
        if @post.save
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("new_post", 
                                  partial: "form",
                                  locals: {post: Post.new}
                                ),
              turbo_stream.prepend("posts", 
                                partial: "post",
                                locals: {post: @post}
                              )
            ]
          end
          format.html { redirect_to site_post_path(id: @post.id), notice: "Post was successfully created." }
        else
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("new_post", 
                                  partial: "form",
                                  locals: {post: @post}
                                )
            ]
          end
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /posts/1 or /posts/1.json
    def update
      respond_to do |format|
        if @post.update(post_params)
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update(@post, 
                                  partial: "post",
                                  locals: {post: @post}
                                )
            ]
          end
          format.html { redirect_to site_post_path(id: @post.id), notice: "Post was successfully updated." }
        else
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update(@post, 
                                  partial: "form",
                                  locals: {post: @post}
                                )
            ]
          end
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /posts/1 or /posts/1.json
    def destroy
      @post.destroy!

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@post)
          ]
        end
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