# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @all_ratings = ['NC-17', 'G', 'PG', 'PG-13', 'R']

    if params[:sort]||params[:ratings]
      case params[:sort]
      when 'title'
        @title_hilite = 'hilite'
       @movies = Movie.order(params[:sort]) 
      when 'release_date'
        @release_hilite = 'hilite'
        @movies = Movie.order(params[:sort])
      end
      case params[:ratings]
      when params[:ratings] ||= @all_ratings
      @ratings = params[:ratings]
      @ratings = @ratings.keys if @ratings.respond_to?(:keys)
      @movies = Movie.where({rating: @ratings})
      end
    else
      @movies=Movie.all
    end

  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
