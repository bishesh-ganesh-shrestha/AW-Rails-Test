class Api::V1::ContentsController < ApplicationController
  before_action :authenticate_request!, except: [ :index ]
  before_action :set_content, only: [ :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  def index
    contents = Content.all
    render json: {
      data: contents.map do |content|
        {
          id: content.id,
          type: "content",
          attributes: {
            title: content.title,
            body: content.body,
            createdAt: content.created_at,
            updatedAt: content.updated_at
          }
        }
      end
    }, status: :ok
  end

  def create
    content = @current_user.contents.build(content_params)
    if content.save
      render json: {
        data: {
          id: content.id,
          type: "content",
          attributes: {
            title: content.title,
            body: content.body,
            createdAt: content.created_at,
            updatedAt: content.updated_at
          }
        }
      }, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      render json: {
        data: {
          id: @content.id,
          type: "content",
          attributes: {
            title: @content.title,
            body: @content.body,
            createdAt: @content.created_at,
            updatedAt: @content.updated_at
          }
        }
      }, status: :ok
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
