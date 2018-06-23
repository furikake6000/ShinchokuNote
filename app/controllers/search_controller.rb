class SearchController < ApplicationController
  def search
    @keyword = params[:search][:keyword]
    
    return if @keyword.empty?

    @notes = Note.where("name LIKE ?", "%#{escape_like(@keyword)}%")
  end
end