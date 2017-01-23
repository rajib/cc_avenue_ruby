class Ccavenue::PaymentResponse
  def initialize
    @working_key = Rails.application.secrets[:ccavenue]['working_key']
  end

  def decrypt_response(response)
    dec_resp = Crypto.decrypt(response, @working_key)

    dec_resp_hash = {}
    dec_resp.split("&").each do |value|
      k,v = value.split('=')
      dec_resp_hash[k] = v
    end

    return dec_resp_hash
  end

  def log_response(params)
    dec_response = decrypt_response(params['encResp'])
    pg_interaction = PaymentInteraction.find(params['orderNo'])
    pg_interaction.response_params = dec_response
    pg_interaction.transaction_status = dec_response['order_status']
    pg_interaction.transaction_amount = dec_response['amount']
    pg_interaction.save!
  end

end
