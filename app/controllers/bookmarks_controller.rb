class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.all
  end

  def new
    @bookmark = Bookmark.new
    @movies = Movie.all
    @list = List.find(params[:list_id])
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @movies = Movie.all
    @list = List.find(params[:list_id])

    if @bookmark.save
      redirect_to list_path(@bookmark.list), notice: 'Bookmark was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list)
  end

  def search
    search_params = params.require(:search).permit(:search)
    search_query = search_params[:search]

    @movies = Movie.where("title LIKE ?", "%#{search_query}%")
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
    render 'new'
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :list_id, :movie_id)
  end
end
