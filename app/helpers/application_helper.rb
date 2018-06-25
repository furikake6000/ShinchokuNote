module ApplicationHelper
  # RbNaClを使用して対象鍵暗号を施す
  require 'rbnacl'
  require 'uri'

  # ページのtitleを提供する
  def full_title(page_title)
    if page_title.empty?
      '進捗ノート'
    else
      page_title + ' | 進捗ノート'
    end
  end

  # yieldの中身があったら描画、なかったらdefaultを描画
  def yield_or_default(y, default)
    if y.empty?
      default
    else
      y
    end
  end

  # 暗号化
  def encrypt_data(data, password, salt)
    key = RbNaCl::Hash.sha256(password)[0..31]
    nonce = RbNaCl::Hash.sha256(salt)[0..23]
    secret_box = RbNaCl::SecretBox.new(key)
    secret_box.encrypt(nonce, data)
  end

  # 復号化
  def decrypt_data(cipherdata, password, salt)
    key = RbNaCl::Hash.sha256(password)[0..31]
    nonce = RbNaCl::Hash.sha256(salt)[0..23]
    secret_box = RbNaCl::SecretBox.new(key)
    data = secret_box.decrypt(nonce, cipherdata)
    # このままだとASCII-8bit形式なので、日本語用にUTF-8に変更
    data.to_s.force_encoding('utf-8')
  end

  # Twitterのサムネイルの原寸バージョンを取得する
  def get_fullsize_thumb_uri(thumb_url)
    thumb_url.to_s.sub(/http/, 'https').sub(/(.*)_normal/, '\1')
  end

  # 文字列からURL部分を取り除く
  def excludelinks(string)
    cpstr = string.dup
    URI.extract(cpstr, %w[http https]).uniq.each do |url|
      cpstr.slice!(url)
      # これだと同じURLが2回以上登場する場合うまくいかないが想定しない
    end
    cpstr
  end

  # イイカンジに働いてくれるTime->Str変換器
  def smart_time_to_str(time)
    time_c = time.dup
    if time_c.to_date == Time.now.to_date
      # 日付が今日だった場合、時刻のみ表示
      I18n.l(time_c.localtime, format: :hour_min)
    elsif time.year == Time.now.year
      # 月日と時刻を表示
      I18n.l(time_c.localtime, format: :date_hour_min)
    else
      # 年月日と時刻を表示
      I18n.l(time_c.localtime, format: :year_date_hour_min)
    end
  end

  # cookie取得
  def getcookie(tag)
    cookies.signed[tag]
  end

  # cookie保存
  def setcookie(tag, value)
    cookies.permanent.signed[tag] = value
  end

  # cookie削除
  def deletecookie(tag)
    cookies.delete(tag)
  end

  # リダイレクト先を保存しておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 記憶したリダイレクト先に戻る
  def redirect_back_or(default)
    # Redirect to session[:forwarding_url], or default if nil
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # テストなどのためにランダム文章を生成する
  def random_sentence
    rand = Random.new
    "I am #{rand(1..10000000)}! Nice to meet you!!"
  end

  # Twitterインテントリンク
  def twitter_intent_link(text, url)
    "https://twitter.com/share?text=#{CGI.escape(text)}&url=#{url}&hashtags=進捗ノート"
  end

  # URLを認識して置換
  # (参考: https://qiita.com/satoken0417/items/df4098a122d05d69a3e6 )
  def replace_url_to_link(text)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      limit_strsize = 30
      show_url = url.size > limit_strsize ? url[0..(limit_strsize - 1)] + '...' : url
      link = "<a href=#{url}>#{show_url}</a>"
      text.gsub! url, link
    end
    text
  end
end
