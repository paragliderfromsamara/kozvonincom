class PhotoTagsController < ApplicationController
  before_action :set_photo_tag, only: [:show, :edit, :update, :destroy]
  before_action :check_grants
  # GET /photo_tags
  # GET /photo_tags.json
  def index
  @photo_tags = PhotoTag.select_by_locale(params[:locale])
	@curTag = PhotoTag.find_by_id(params[:tag_id])
	@photos = []
	@photos = @curTag.photos if !@curTag.nil?
  end

  # GET /photo_tags/1
  # GET /photo_tags/1.json
  def show
  end

  # GET /photo_tags/new
  def new
    @photo_tag = PhotoTag.new
  end

  # GET /photo_tags/1/edit
  def edit
  end

  # POST /photo_tags
  # POST /photo_tags.json
  def create
    @photo_tag = PhotoTag.new(photo_tag_params)

    respond_to do |format|
      if @photo_tag.save
        format.html { redirect_to @photo_tag, notice: 'Photo tag was successfully created.' }
        format.json { render :show, status: :created, location: @photo_tag }
      else
        format.html { render :new }
        format.json { render json: @photo_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_tags/1
  # PATCH/PUT /photo_tags/1.json
  def update
    respond_to do |format|
      if @photo_tag.update(photo_tag_params)
        format.html { redirect_to @photo_tag, notice: 'Photo tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_tag }
      else
        format.html { render :edit }
        format.json { render json: @photo_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_tags/1
  # DELETE /photo_tags/1.json
  def destroy
    @photo_tag.destroy
    respond_to do |format|
      format.html { redirect_to photo_tags_url, notice: 'Photo tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_tag
      @photo_tag = PhotoTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_tag_params
      params.require(:photo_tag).permit(:name)
    end
    
    def check_grants
        redirect_to '/404' if !signed_in?
    end
end
