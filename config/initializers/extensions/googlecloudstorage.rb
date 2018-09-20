require "google/cloud/storage"

module GCSFileSignerExtension
  # Remove 'storage.googleapis.com' from url
  def ext_url
    "https:/#{ext_path}"
  end

  # Longer expire time (4 hours)
  def signed_url(options)
    options[:expires] = 14_400

    options = apply_option_defaults options

    i = determine_issuer options
    s = determine_signing_key options

    raise SignedUrlUnavailable unless i && s

    sig = generate_signature s, signature_str(options)
    generate_signed_url i, sig, options[:expires], options[:query]
  end
end

Google::Cloud::Storage::File::Signer.prepend(GCSFileSignerExtension)