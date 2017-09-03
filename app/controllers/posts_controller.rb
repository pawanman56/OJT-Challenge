class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:update, :edit, :destroy]

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(post_params)

    if @post.save
      flash[:success] = "post created successfully"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    @post.update(post_params)
    if @post.save
      flash[:success] = "post edited suceessfully"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to root_url
  end

  private

    def post_params
      params.require(:post).permit(:user_id, :title, :description)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
