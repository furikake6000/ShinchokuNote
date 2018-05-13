module ErrorHandlingHelper
  # 参考: https://gist.github.com/itskingori/aae9a1905cec47f7fd52

  # 404 Not Found
  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('public/404.html'), status: 404, layout: false }
      format.xml { render xml: 'Not Found', status: 404 }
      format.json { render json: 'Not Found', status: 404 }
    end
  end

  # 403 Forbidden
  def render_403
    respond_to do |format|
      format.html { render file: Rails.root.join('public/403.html'), status: 403, layout: false }
      format.xml { render xml: 'Forbidden', status: 403 }
      format.json { render json: 'Forbidden', status: 403 }
    end
  end

  # 401 Unauthorized
  def render_401
    respond_to do |format|
      format.html { render file: Rails.root.join('public/401.html'), status: 401, layout: false }
      format.xml { render xml: 'Unauthorized', status: 401 }
      format.json { render json: 'Unauthorized', status: 401 }
    end
  end

  # 400 Bad Request
  def render_400
    respond_to do |format|
      format.html { render file: Rails.root.join('public/400.html'), status: 400, layout: false }
      format.xml { render xml: 'Unauthorized', status: 400 }
      format.json { render json: 'Unauthorized', status: 400 }
    end
  end

  # 500 Internal Error
  def render_500
    respond_to do |format|
      format.html { render file: Rails.root.join('public/500.html'), status: 500, layout: false }
      format.xml { render xml: 'Internal Error', status: 500 }
      format.json { render json: 'Internal Error', status: 500 }
    end
  end
end
