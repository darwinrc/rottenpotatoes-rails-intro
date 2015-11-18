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
    if params[:sort] 
      session[:sort] = params[:sort]
      if params[:rating]
	session[:ratings] = params[:rating]
      end
      if session[:ratings]
        @movies = Movie.order(params[:sort]).where(rating: session[:ratings].keys)
      else
        @movies = Movie.order(params[:sort]).all
      end
      if params[:sort] == 'title'
        @title_hilite = 'hilite'
        @release_date_hilite = ''
      else
        @title_hilite = ''
        @release_date_hilite = 'hilite'
      end	
    else
      if params[:ratings]
	session[:ratings] = params[:ratings]
      end
      if session[:ratings]
        @movies = Movie.where(rating: session[:ratings].keys)
      else
	@movies = Movie.all
      end
    end
    if params[:sort] and params[:ratings]
	    #refactor
    else
      flash.keep
#      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
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
