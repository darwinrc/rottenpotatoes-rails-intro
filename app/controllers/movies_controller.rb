class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
   
    if params[:ratings]
      @selected_ratings = session[:ratings] = params[:ratings]
      if params[:sort]
        @sort = session[:sort] = params[:sort]
	@movies = Movie.order(@sort).where(rating: @selected_ratings.keys)
	@title_hilite = 'hilite' if @sort == 'title'
	@release_date_hilite = 'hilite' if @sort == 'release_date'
      else
	@movies = Movie.where(rating: @selected_ratings.keys)
      end
    else
      if session[:sort]
        @sort = session[:sort]
      end

      if session[:ratings]
	@selected_ratings = session[:ratings]
      else
        initial_ratings = {}
        @all_ratings.each do |rating|
          initial_ratings["#{rating}"] = "ratings[#{rating}]"
        end
        @selected_ratings = initial_ratings
      end
      @movies = Movie.all
      flash.keep
      if @sort
        redirect_to movies_path(sort: @sort, ratings: @selected_ratings) and return
      else
        redirect_to movies_path(ratings: @selected_ratings) and return
      end 
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
