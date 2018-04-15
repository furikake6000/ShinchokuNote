class TweetPostsController < ApplicationController
  require 'tempfile'

  protect_from_forgery except: :imgsig
  before_action -> { load_note_as_mine :note_id }, only: %i[create]

  def create
    @post = tweetpost_from_params(@note)
    if @post.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  def imgsig
    # Making params
    reqparams = {
      'oauth_token': current_user_token,
      'oauth_consumer_key': Rails.application.secrets.twitter_api_key,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_version': '1.0'
    }
    reqparams.merge!(imgsig_params)

    # Generating & escaping key and params
    sig_key = CGI.escape(Rails.application.secrets.twitter_api_secret) +
             '&' +
             CGI.escape(current_user_secret)
    method_data = CGI.escape('POST')
    requesturl_data = CGI.escape('https://upload.twitter.com/1.1/media/upload.json')
    reqparams_data = CGI.escape(reqparams.to_query)
    sig_data = method_data + '&' + requesturl_data + '&' + reqparams_data

    # Generating auth key
    digest = OpenSSL::Digest.new('sha1')
    signature = OpenSSL::HMAC.digest(digest, sig_key, sig_data)
    signature_base64 = Base64.strict_encode64(signature)

    response = {
      'params': reqparams,
      'signature': signature_base64
    }

    Tempfile.open { |t|
      t.binmode
      print("BASE64 DATA:" + reqparams['media_data'][0, 100])
      mime_type = reqparams['media_data'].slice(0..reqparams['media_data'].index(';'))
      data = reqparams['media_data'].slice(reqparams['media_data'].index(';') + 8..-1)
      print("MIME_TYPE: " + mime_type)
      print("DATA[100]: " + data[0, 100])
      t.write Base64.decode64(data)

      client = client_new
      client.update_with_media("hoge", t.path)
     }

    render json: response
  end

  private

  # paramsからtweetを取得
  def tweetpost_from_params(note)
    client = client_new

    # ツイートを生成
    if params[:post][:twitter_id]
      # Get tweet
      tweet_id = params[:post][:twitter_id].split('/').last
      tweet = client.status(tweet_id)
      # flash
      flash[:success] = 'ツイートをノートに紐付けました！'
    elsif params[:post][:text]
      # Post new tweet
      if params[:post][:response_to]
        # 返信ありの場合
        responded_comment = Comment.find(params[:post][:response_to])
        # 返信先のコメントのテキスト、文字数の最大制限を求める
        responded_comment_maxlen = 140 - 10 - params[:post][:text].length
        # 必要に応じて載せるコメントを切り貼りする
        responded_comment_text = 
          responded_comment.text.length > responded_comment_maxlen ?
          '> ' + responded_comment.text[0..responded_comment_maxlen - 3] + '...' :
          '> ' + responded_comment.text
        # つぶやく文字列を決定
        tweetstr = responded_comment_text + "\n" +
                   params[:post][:text] + "\n" +
                   comment_url(responded_comment, only_path: false) +
                   " #進捗ノート"
        # 画像の有無を判別し投稿
        tweet = params[:post][:image] ?
                  client.update_with_media(
                    tweetstr,
                    params[:post][:image].map{ |img| img.tempfile }
                  ) :
                  client.update(tweetstr)
      else
        # 返信なしの場合
        # つぶやく文字列を決定
        tweetstr = params[:post][:text] + "\n" +
                   comment_url(responded_comment, only_path: false) +
                   " #進捗ノート"
        # 画像の有無を判別し投稿
        tweet = params[:post][:image] ?
        client.update_with_media(
          tweetstr,
          params[:post][:image].map{ |img| img.tempfile }
        ) :
        client.update(tweetstr)
      end

      # flash
      flash[:success] = '新しくツイートを投稿しました！'
    end

    # 投稿したツイートを元にPostを作成
    newpost = tweet_to_tweetpost(tweet, note)
    if params[:post][:response_to]
      # Response処理
      newpost.responded_comment = responded_comment
      tweet_hash = tweet.to_hash
      tweet_hash['text'] = params[:post][:text]
      newpost.text = tweet_hash.to_json

      # responded_commentの既読処理はしておく
      responded_comment.read_flag = true
    end
    newpost
  end

  # TweetからTweetPostオブジェクトを作成する
  def tweet_to_tweetpost(tweet, note)
    tweetpost = note.posts.new(type: 'TweetPost')
    tweetpost.twitter_id = tweet.id
    # Text取得
    tweetpost.text = tweet.to_json
    # 作成したTweetPostを返す
    tweetpost
  end

  # imgsigのparams
  def imgsig_params
    params.permit(:media_data, :oauth_callback, :oauth_consumer_key,
                  :oauth_nonce, :oauth_signature_method, :oauth_timestamp,
                  :oauth_version)
  end
end
