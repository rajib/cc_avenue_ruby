module Crypto
  def self.encrypt(plain_text, key)
    @init_vector = (0..15).to_a.pack("C*")
    secret_key =  [Digest::MD5.hexdigest(key)].pack("H*")
    cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
    cipher.encrypt
    cipher.key = secret_key
    cipher.iv  = @init_vector
    encrypted_text = cipher.update(plain_text) + cipher.final
    return (encrypted_text.unpack("H*")).first
  end

  def self.decrypt(cipher_text, key)
    @init_vector = (0..15).to_a.pack("C*")
    secret_key =  [Digest::MD5.hexdigest(key)].pack("H*")
    encrypted_text = [cipher_text].pack("H*")
    decipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.key = secret_key
    decipher.iv  = @init_vector
    decrypted_text = (decipher.update(encrypted_text) + decipher.final).gsub(/\0+$/, '')
    return decrypted_text
  end
end
