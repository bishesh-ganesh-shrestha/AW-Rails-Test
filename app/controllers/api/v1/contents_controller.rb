class Api::V1::ContentsController < ApplicationController
  before_action :authenticate_request!, except: [ :index ]
  before_action :set_content, only: [ :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  def index
    contents = Content.all
    render json: ContentSerializer.new(contents).serializable_hash, status: :ok
  end

  def create
    content = @current_user.contents.build(content_params)
    if content.save
      render json: ContentSerializer.new(content).serializable_hash, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      render json: ContentSerializer.new(@content).serializable_hash, status: :ok
    else
      render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @content.destroy
      render json: { message: "Deleted" }, status: :ok
    else
      render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_content
    @content = Content.find_by(id: params[:id])
    unless @content
      render json: { error: "Content not found" }, status: :not_found
    end
  end

  def authorize_user!
    unless @content.user_id == @current_user.id
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden
    end
  end

  def content_params
    params.permit(:title, :body)
  end
end
