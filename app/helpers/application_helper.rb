module ApplicationHelper

  #秘密鍵暗号方式（AES-256-CBC）でデータを暗号化する
  #引用元（http://webos-goodies.jp/archives/encryption_in_ruby.html）
  #暗号化
  def encrypt_data(data, password, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.pkcs5_keyivgen(password, salt)
    cipher.update(data) + cipher.final
  end
  #復号化
  def decrypt_data(data, password, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.pkcs5_keyivgen(password, salt)
    cipher.update(data) + cipher.final
  end

end
