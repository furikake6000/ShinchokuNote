class SearchController < ApplicationController
  def search
    @keyword = params[:search][:keyword]
  end
end