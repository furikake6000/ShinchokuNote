require "google/cloud/storage"

module GCSFileSignerExtension
  def ext_url
    "https:/#{ext_path}"
  end
end

Google::Cloud::Storage::File::Signer.prepend(GCSFileSignerExtension)