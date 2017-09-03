class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :correct_user,   only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comments_params.merge(user_id: current_user.id))
    if @comment.save
      flash[:success] = "your comment is added successfully"
      redirect_to root_url
    else
      flash[:danger] = "Invalid attributes"
      redirect_to root_url
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to root_url
  end

  private

    def comments_params
      params.require(:comment).permit(:text, :post_id)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end

end
