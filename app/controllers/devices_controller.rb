class DevicesController < ApplicationController
  # 参考:(https://www.lanches.co.jp/blog/6723)

  def create
    return unless logged_in?
    device = current_user.devices.find_or_initialize_by endpoint: params[:subscription][:endpoint]
    device.attributes = device_params
    device.save! if device.changed?
    head :ok
  end

  private

  def device_params
    p1 = params.require(:subscription).permit(:endpoint)
    p2 = params.require(:subscription)
               .require(:keys)
               .permit(:p256dh, :auth)
    p1.merge p2
  end
end