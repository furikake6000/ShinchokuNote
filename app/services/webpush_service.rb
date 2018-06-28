class WebpushService
  # 参考: (https://www.lanches.co.jp/blog/6723)

  def initialize(user_id: nil)
    @user_id = user_id
  end

  def webpush(message)
    devices.each do |device|
      webpush_to_device device, message
    end
  end

  private

  def webpush_to_device(device, message)
    Webpush.payload_send(
      message: message,
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
    @user_id.present? ? Device.where(user_id: @user_id) : Device.all
  end
end