class WebpushService
  # 参考: (https://www.lanches.co.jp/blog/6723)

  def initialize(user: nil)
    @user = user
  end

  def webpush(text, title: '進捗ノート', target_url: '/')
    devices.each do |device|
      webpush_to_device device,
                        text,
                        title: title,
                        target_url: target_url
    end
  end

  private

  def webpush_to_device(device, text, title: '進捗ノート', target_url: '/')
    message = {
      icon: '/icon.png',
      title: title,
      body: text,
      target_url: target_url
    }

    Webpush.payload_send(
      message: message.to_json,
      endpoint: device.endpoint,
      p256dh: device.p256dh,
      auth: device.auth,
      ttl: 24 * 60 * 60,
      vapid: {
        public_key: Rails.application.credentials.vapid[:public_key],
        private_key: Rails.application.credentials.vapid[:private_key]
      }
    )
  end

  def devices
    @user.present? ? Device.where(user: @user) : Device.all
  end
end