module ActiveStorageBlobControllerExtension
  def show
    expires_in 3.hours, public: true
    redirect_to @blob.service_url(disposition: params[:disposition], expires_in: 3.hours)
  end
end

ActiveStorage::BlobsController.prepend(ActiveStorageBlobControllerExtension)