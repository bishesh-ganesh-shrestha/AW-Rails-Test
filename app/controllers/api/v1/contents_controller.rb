# Handles content-related endpoints
class Api::V1::ContentsController < ApplicationController
  before_action :authenticate_request!, except: [ :index ]
  before_action :set_content, only: [ :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  # GET /api/v1/content
  # Returns all contents
  #
  # @return [JSON] list of contents
  def index
    contents = Content.all
    render json: ContentSerializer.new(contents).serializable_hash, status: :ok
  end

  # POST /api/v1/contents
  # Creates a new content
  #
  # @return [JSON] created content or error messages
  def create
    content = @current_user.contents.build(content_params)
    if content.save
      render json: ContentSerializer.new(content).serializable_hash, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/contents/:id
  # Updates a content
  #
  # @return [JSON] updated content or error messages
  def update
    if @content.update(content_params)
      render json: ContentSerializer.new(@content).serializable_hash, status: :ok
    else
      render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/contents/:id
  # Deletes a content
  #
  # @return [JSON] success message or error messages
  def destroy
    if @content.destroy
      render json: { message: "Deleted" }, status: :ok
    else
      render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Finds content by ID
  #
  # @return [JSON] content or not found error
  def set_content
    @content = Content.find_by(id: params[:id])
    unless @content
      render json: { error: "Content not found" }, status: :not_found
    end
  end

  # Ensures current user owns the content
  #
  # @return [JSON] forbidden error if unauthorized
  def authorize_user!
    unless @content.user_id == @current_user.id
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden
    end
  end

  # Permitted content parameters
  #
  # @return [ActionController::Parameters]
  def content_params
    params.permit(:title, :body)
  end
end
