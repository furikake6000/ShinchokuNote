class SearchController < ApplicationController
  def search
    @keyword = params[:search][:keyword]

    return if @keyword.empty?

    @notecount = Note.where('name LIKE ?', "%#{escape_like(@keyword)}%").count
    @notes = Note.where('name LIKE ?', "%#{escape_like(@keyword)}%")
                 .order('created_at DESC')
                 .paginate(page: params[:page], per_page: 30)
  end
end
