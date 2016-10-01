class PhotosController < ApplicationController
  include PhotosHelper
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  #before_action :check_grants, only: [:index, :new, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = []
    t_ids = params[:tags].blank? ? [] : params[:tags].getArrScobes
    c_ids = params[:categories].blank? ? [] : params[:categories].getArrScobes
    if t_ids.blank? && c_ids.blank?
    	album = Album.find_by(id: params[:album_id].to_i)
    	@type = (params[:ph_type] != nil)? params[:ph_type] : "none"
    	@size = (params[:ph_size] != nil)? params[:ph_size] : "none"
      @title = @header = t ".header"
    	if album != nil
    		@photos = album.photos
    	else
    		@photos = Photo.all
    	end
    else
      session[:filter_tags] = t_ids
      session[:filter_categories] = c_ids
      @photos = getFilterPhotos(t_ids, c_ids)
    end
    respond_to do |format|
      format.html
      format.json {render json: listing_photos_json}
    end

  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photos = []
    if !params[:tags].blank? || !params[:categories].blank?
      t_ids = params[:tags].blank? ? [] : params[:tags].getArrScobes
      c_ids = params[:categories].blank? ? [] : params[:categories].getArrScobes
      @photos = getFilterPhotos(t_ids, c_ids)
    else
      @album = @photo.album
      @photos = @photo.album.photos if !@photo.album.nil?
    end
    @idx = params[:index].nil? ? @photos.to_a.index(@photo) : params[:index].to_i
  end

  # GET /photos/new
  def new
    @photo = Photo.new
	  @album = Album.new
  end

  # GET /photos/1/edit
  def edit
  end

  def edit_photos
	@album = Album.find_by(id: params[:album_id])
	@tag = PhotoTag.find_by(id: params[:photo_tag_id])
	if @album != nil
		@photos = @album.photos
		@header = "Изменение фотографий альбома"
	elsif @tag != nil
		@photos = @tag.photos
		@header = "Изменение фотографий тэга"
	else
		@header = "Изменение фотографий"
		@photos = Photo.where(album_id: [nil, 0])
	end
	#redirect_to '/404' if @photos == []
  end
  
  def edit_slider_copy
	@photo = Photo.find(params[:id])
	
  end
  
  def update_slider_copy
	@photo = Photo.find(params[:id])
	@photo.x = params[:photo][:x].to_i*-1
	@photo.y = params[:photo][:y].to_i*-1
	@photo.w = params[:photo][:w].to_i
	@photo.h = params[:photo][:h].to_i
	redirect_to @photo if @photo.cropPhotoForSlider
  end
  
  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        #format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
		respond_to do |format|
			if @photo.destroy
				@photos = Photo.all
				format.html { render "index", notice: 'Photo was successfully destroyed.' }
				format.json { render status: :ok }
			end
		end
  end
  
  def reset_filter
    respond_to do |format|
        if (!params[:categories].nil? && !params[:tags].nil?) && (params[:tags].blank?&&params[:categories].blank?)
          session[:filter_tags] = []
          session[:filter_categories] = []
          format.json {render json: 'success'}
        else
          format.json {render json: 'не удалось сбросить фильтр'}
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:album_id, :name, :description, :get_at, :link, :ru_tag_names, :com_tag_names, :is_album_photo, :is_category_photo, :bg_opacity)
    end
    
    def check_grants
        
    end
end
