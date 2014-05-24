# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    session[:ratings] = params[:ratings].keys if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]

    if session[:ratings] || session[:sort]
      case session[:sort]
      when 'title'
        @title_hilite = 'hilite'
      when 'release_date'
        @release_hilite = 'hilite'
      end

      @movies = Movie.find(:all, order: ["? ASC", session[:sort]],
                                 conditions: ["rating IN (?)", session[:ratings]])
    else
      @movies = Movie.all
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
