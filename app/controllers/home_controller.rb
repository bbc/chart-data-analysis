class HomeController < ApplicationController
  def index
    redirect_to charts_path
  end
end
