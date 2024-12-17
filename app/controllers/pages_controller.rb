class PagesController < ApplicationController
  before_action :authenticate_account!, only: :home
  def home
  end
end
