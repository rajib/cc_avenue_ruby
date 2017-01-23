class Ccavenue::Payment

  def initialize(user, pg_transaction)
    @user = user
    @order_id = pg_transaction.id
    @amount = '18000'
    @merchant_id = Rails.application.secrets[:ccavenue]['merchant_id']
    @working_key = Rails.application.secrets[:ccavenue]['working_key']
    @access_code = Rails.application.secrets[:ccavenue]['access_code']

    @redirect_url = ActionMailer::Base.default_url_options[:protocol]+'://'+ActionMailer::Base.default_url_options[:host]+"/users/#{@user.id}/ccavenue_response"
    @cancel_url = ActionMailer::Base.default_url_options[:protocol]+'://'+ActionMailer::Base.default_url_options[:host]+"/users/#{@user.id}/ccavenue_cancel_request"
  end

  def request_params
    {
      'merchant_id': @merchant_id,
      'order_id': @order_id,
      'currency': 'INR',
      'amount': @amount,
      'redirect_url': @redirect_url,
      'cancel_url': @cancel_url,
      'language': 'en',
      'billing_name': @user.name,
      'customer_identifier': @user.id
    }
  end

  def payload
    data = ""
    request_params.each do |key, value|
      data += key.to_s+"="+value.to_s+"&"
    end
    data
  end

  def encrypt_request
    Crypto.encrypt(payload, @working_key)
  end

end
