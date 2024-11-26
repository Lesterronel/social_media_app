class CommentsController < SiteController
  skip_before_action :authenticate_user!, only: [:index, :show, :index_for_post]
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  def index_for_post
    @post = Post.find(params[:post_id]) # Find the post by its ID
    @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)      # Fetch all comments associated with the post
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comments_count = Comment.where(post_id: params[:post_id]).count
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    # debugger
    @comment = Comment.new(comment_params)
    @post = Post.find(comment_params[:post_id])

    @comments_count = params[:comment][:comment_qty].to_i

    respond_to do |format|
      if @comment.save

        if @comments_count > 0
          @comments_count += 1
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("form_comment#{comment_params[:post_id]}", 
                                  partial: "form",
                                  locals: {comment: Comment.new, post: @post, comments_count: @comments_count}
                                ),
              turbo_stream.prepend("comments#{comment_params[:post_id]}", 
                                partial: "comment",
                                locals: {comment: @comment}
                              )
            ]
          end
        else
          @comments_count += 1
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("comments#{comment_params[:post_id]}", html: ""),
              turbo_stream.update("form_comment#{comment_params[:post_id]}", 
                                  partial: "form",
                                  locals: {comment: Comment.new, post: @post}
                                ),
              turbo_stream.prepend("comments#{comment_params[:post_id]}", 
                                partial: "comment",
                                locals: {comment: @comment}
                              )
            ]
          end
        end
          
        format.html { redirect_to @comment, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

    # respond_to do |format|
    #   if @post.save
    #     format.turbo_stream do
    #       render turbo_stream: [
    #         turbo_stream.update("new_post", 
    #                             partial: "index_for_post.html",
    #                             locals: {post: Post.new}
    #                           ),
    #         turbo_stream.prepend("posts", 
    #                           partial: "post",
    #                           locals: {post: @post}
    #                         )
    #       ]
    #     end
    #     format.html { redirect_to site_post_path(id: @post.id), notice: "Post was successfully created." }
    #   else
    #     format.turbo_stream do
    #       render turbo_stream: [
    #         turbo_stream.update("new_post", 
    #                             partial: "form",
    #                             locals: {post: @post}
    #                           )
    #       ]
    #     end
    #     format.html { render :new, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to comments_path, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :user_id, :post_id, :content ])
    end
end
