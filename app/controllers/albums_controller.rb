class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :check_grants, only: [:new, :create, :edit, :update, :destroy, :index, :upload_photos]
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.where(is_draft: false)
    @header = @title = t ".header"
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @title = @header = @album.loc_name(cur_locale)
	@photos = @album.photos
  end

  # GET /albums/new
  def new
    @album = Album.get_draft
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Альбом успешно добавлен.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Альбом успешно обновлён.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_photos
	@photo = Photo.new(:album_id => params[:photo][:album_id], :link => params[:photo][:link], :ru_tag_names => '', :com_tag_names => '')
	if @photo.save
		render :json => @photo.jsonObj
	else
		render :json => {:error => @photo.errors.full_messages.join(',')}, :status => 400
	end
  end
  
  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:category_id, :name, :get_at, :uploaded_photos, :is_enable, :is_draft, :content)
    end
    def check_grants
        redirect_to '/404' if !signed_in?
    end
end
