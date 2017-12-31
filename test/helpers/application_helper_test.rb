require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "Encryption and decryption" do
    str = "Hello, Ruby world."
    pass = "I_am_a_Password"
    salt = SecureRandom.random_bytes(8)

    encrypted = encrypt_data(str, pass, salt)

    decrypted = decrypt_data(encrypted, pass, salt)

    assert_equal(str, decrypted, "Decrypted string does not match with primary string.")
  end

  test "Encryption and decryption for Unicode" do
    str = "こんにちは、Rubyの世界"
    pass = "I_am_a_Password"
    salt = SecureRandom.random_bytes(8)

    encrypted = encrypt_data(str, pass, salt)

    decrypted = decrypt_data(encrypted, pass, salt)

    assert_equal(str, decrypted, "Decrypted string(Unicode) does not match with primary string.")
  end
end
