class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    if !logged_in?
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def add_points
    if logged_in?
     points = @current_user.points
      if not points
        points = 0
      end
      @current_user.points = points + 1
      @current_user.save
    end
    redirect_back(fallback_location: root_path)
  end
end
