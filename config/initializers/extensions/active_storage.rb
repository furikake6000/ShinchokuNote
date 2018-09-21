module ActiveStorageBlobControllerExtension
  def show
    expires_in 3.hours, public: true

    generated_url = Rails.cache.fetch("blob_#{@blob.id}_signed_url", expires_in: 3.hours) do
      @blob.service_url(disposition: params[:disposition], expires_in: 3.hours)
    end
    redirect_to generated_url
  end
end

ActiveStorage::BlobsController.prepend(ActiveStorageBlobControllerExtension)