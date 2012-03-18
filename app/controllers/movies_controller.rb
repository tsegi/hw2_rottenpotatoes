class MoviesController < ApplicationController

  def patch_params
  
     @params_changed = false
  
     if (params[:ratings] != nil)
      session[:ratings] = params[:ratings]
     elsif (session[:ratings] != nil)
      params[:ratings] = session[:ratings]
      @params_changed = true
     end
     
     if (params[:sort_by] != nil)
      session[:sort_by] = params[:sort_by]
     elsif (session[:sort_by] != nil)
      params[:sort_by] = session[:sort_by]
      @params_changed = true
     end
      
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    self.patch_params
    if (@params_changed)
      redirect_to :action => "index", :ratings => params[:ratings], :sort_by => params[:sort_by]
    end
  
    @all_ratings = Movie.all_ratings

    @sort_by = params[:sort_by]
  
    @sort_by_title = (params[:sort_by] == "title")
    @sort_by_release_date = (params[:sort_by] == "release_date")
    
    @movies = Movie.select("*");
   
    if (params[:ratings] != nil)
      @selected_ratings = params[:ratings]
      @movies = @movies.where("rating in (?)", @selected_ratings.keys)
    else
      @selected_ratings = {}
    end
    
    if (@sort_by != nil)
      @movies = @movies.order(@sort_by)
    end   
    
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
