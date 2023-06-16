class PostsController < ApplicationController
  # before_action :authorize_request
  before_action :set_user
  before_action :set_post, only: [:show, :update, :destroy]

  def show
    render json: @post, include: { user: { only: [:id, :name, :email] } }, status: :ok
  end

  def create
    @post = @user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def set_post
    @post = @user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
