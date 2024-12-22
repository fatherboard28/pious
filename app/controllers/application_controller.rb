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

  def log_daily_reading
    add_points(1)
  end

  def log_bible_reading
    book = params[:book]

    BOOKS.each do |b|
      if b[0] == book
        add_points(b[1])
      end
    end
  end

  private
  def add_points(p)
    Rails.logger.debug "Points: #{p}\n"
    if logged_in?
     cur_points = @current_user.points
      if not cur_points
        cur_points = 0
      end
      @current_user.points = cur_points + p
      @current_user.save
    end
    redirect_back(fallback_location: root_path)
  end
end
