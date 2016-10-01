class PhotoTagReferencesController < ApplicationController
  before_action :set_photo_tag_reference, only: [:show, :edit, :update, :destroy]
  before_action :check_grants, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  # GET /photo_tag_references
  # GET /photo_tag_references.json
  def index
    @photo_tag_references = PhotoTagPhoto.all
  end

  # GET /photo_tag_references/1
  # GET /photo_tag_references/1.json
  def show
  end

  # GET /photo_tag_references/new
  def new
    @photo_tag_reference = PhotoTagPhoto.new
  end

  # GET /photo_tag_references/1/edit
  def edit
  end

  # POST /photo_tag_references
  # POST /photo_tag_references.json
  def create
    @photo_tag_reference = PhotoTagPhoto.new(photo_tag_reference_params)

    respond_to do |format|
      if @photo_tag_reference.save
        format.html { redirect_to @photo_tag_reference, notice: 'Photo tag reference was successfully created.' }
        format.json { render :show, status: :created, location: @photo_tag_reference }
      else
        format.html { render :new }
        format.json { render json: @photo_tag_reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_tag_references/1
  # PATCH/PUT /photo_tag_references/1.json
  def update
    respond_to do |format|
      if @photo_tag_photo.update(photo_tag_reference_params)
        format.html { redirect_to @photo_tag_reference, notice: 'Photo tag reference was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_tag_reference }
      else
        format.html { render :edit }
        format.json { render json: @photo_tag_reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_tag_references/1
  # DELETE /photo_tag_references/1.json
  def destroy
    @photo_tag_reference.destroy
    respond_to do |format|
      format.html { redirect_to photo_tag_references_url, notice: 'Photo tag reference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_tag_reference
      @photo_tag_reference = PhotoTagPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_tag_reference_params
      params.require(:photo_tag_photo).permit(:photo_id, :photo_tag_id)
    end
    
    def check_grants
        redirect_to '/404' if !signed_in?
    end
end
