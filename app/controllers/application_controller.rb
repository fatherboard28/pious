class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :validate_book_param, only: [:log_bible_reading]
  helper_method :user_books

  # endpoint action for index
  def index
    redirect_to login_path unless logged_in?
  end

  # for getting current user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # endpoint action for /daily
  def log_daily_reading
    return unless logged_in?

    add_points(1)
  end

  # endpoint action for /bible
  def log_bible_reading
    return unless logged_in?

    book = params[:book]

    unless book
      Rails.logger.debug "No Book entered #{book}"
      return
    end

    user_books.each do |b|
      complete_book(book, b[1]) if b[0] == book && !b[2]
    end
  end

  # Helper method for getting all books for user
  # returns array of objects in this shape
  # ["book", "point_val", has_read :bool]
  #
  # TODO:
  # - Make block on completeing book lift after 1 year, 1 month or some other thing?
  def user_books
    completed_books = BibleReading.where("uid = ?", @current_user.id).pluck(:book)
    ret = []

    BOOKS.each do |b|
      Rails.logger.debug b
      ret.push([b[0], b[1], completed_books.to_a.include?(b[0]) ])
    end
    ret
  end

  private

  # writes to db table BibleReading for current_user to complete given book,
  # then calls method to add points
  def complete_book(book, pnt)
    return if BibleReading.where(uid: @current_user.id).include?(book)

    add_points(pnt)
    BibleReading.create(book: book, uid: @current_user.id)
  end

  # writes to db table User for current_user to add given points
  def add_points(pnt)
    cur_points = @current_user.points
    cur_points ||= 0
    @current_user.points = cur_points + pnt
    @current_user.save
    redirect_back(fallback_location: root_path)
  end

  # validates params for log_bible_reading
  def validate_book_param
    false unless params[:book].present? && params[:post_type].present?
  end

  def logged_in?
    current_user
  end
end
