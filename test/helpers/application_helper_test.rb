require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  test 'Encryption and decryption' do
    str = 'Hello, Ruby world.'
    pass = 'I_am_a_Password'
    salt = SecureRandom.random_bytes(8)

    encrypted = encrypt_data(str, pass, salt)
    decrypted = decrypt_data(encrypted, pass, salt)

    assert_equal str, decrypted
  end

  test 'Encryption and decryption for Unicode' do
    str = 'こんにちは、Rubyの世界'
    pass = 'I_am_a_Password'
    salt = SecureRandom.random_bytes(8)

    encrypted = encrypt_data(str, pass, salt)

    decrypted = decrypt_data(encrypted, pass, salt)

    assert_equal str, decrypted
  end

  test 'Encryption and decryption for Json' do
    hash = {
      name: 'furikake',
      sukinamono: ['Sushi🍣', 'Nekomimi girl🐾'],
      prof: { age: 3, height: 121, weight: 38 },
      its_a: 'Joke!'
    }
    json = JSON.generate(hash)
    pass = 'I_am_a_Password'
    salt = SecureRandom.random_bytes(8)

    encrypted = encrypt_data(json, pass, salt)
    decryptedjson = decrypt_data(encrypted, pass, salt)

    assert_equal json, decryptedjson

    decryptedhash = JSON.parse(decryptedjson, symbolize_names: true)

    assert_equal hash, decryptedhash
  end

  test 'get_fullsize_thumb_uri' do
    thumb_url = 'http://pbs.twimg.com/profile_images/962856023206674432/5khbioGO_normal.jpg'
    fullsize_thumb_url = 'https://pbs.twimg.com/profile_images/962856023206674432/5khbioGO.jpg'
    assert_equal get_fullsize_thumb_uri(thumb_url), fullsize_thumb_url
  end
end
