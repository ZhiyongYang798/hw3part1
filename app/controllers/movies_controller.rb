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
    #there is sth worng when I commiting my code.So I add the code of each step here as comments
    #Qustion 1:
    #if params[:sort]
    #  case params[:sort]
    #  when 'title'
    #    @title_hilite = 'hilite'
    #  when 'release_date'
    #    @release_hilite = 'hilite'
    #  end
    #  @movies=Movie.order(params[:sort])
    #else
    #  @movies=Movie.all
    #  end

    #Question 2:
    # @all_ratings = ['NC-17', 'G', 'PG', 'PG-13', 'R']

    #if params[:sort]||params[:ratings]
    #  case params[:sort]
    #  when 'title'
    #    @title_hilite = 'hilite'
    #   @movies = Movie.order(params[:sort]) 
    #  when 'release_date'
    #    @release_hilite = 'hilite'
    #    @movies = Movie.order(params[:sort])
    #  end
    #  case params[:ratings]
    #  when params[:ratings] ||= @all_ratings
    #  @ratings = params[:ratings]
    #  @ratings = @ratings.keys if @ratings.respond_to?(:keys)
    #  @movies = Movie.where({rating: @ratings})
    #  end
    #else
    #  @movies=Movie.all
    #end
    
    @all_ratings = ['NC-17', 'G', 'PG', 'PG-13', 'R']

    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort]    = params[:sort]    if params[:sort]

    if session[:ratings] || session[:sort]
      case session[:sort]
      when 'title'
        @title_hilite = 'hilite'
      when 'release_date'
        @release_hilite = 'hilite'
      end

      session[:ratings] ||= @all_ratings
      @ratings = session[:ratings]
      @ratings = @ratings.keys if @ratings.respond_to?(:keys)
      @movies = Movie.where({rating: @ratings}).order(session[:sort])
    else
      @movies = Movie.all
    end

    if session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
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
