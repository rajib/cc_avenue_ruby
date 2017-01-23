class PatientsController < ApplicationController # :nodoc:
  # Step 2 For Registration
  def enter_subscription_details
  end

  def ccavenue_request
    pg_transaction = @user.create_payment_interaction_with_cc_avenue_request_params
    @encrypted_data = Ccavenue::Payment.new(@user, pg_transaction).encrypt_request
  end

  def ccavenue_response
    Rails.logger.info params
    begin
      result = Ccavenue::PaymentResponse.new.log_response(params)
    rescue Exception => e
      @error_message = "Error occurred: #{e.message}"
      AdminNotificationMailer.exception_notification(request, current_user, params, e).deliver
      redirect_to enter_subscription_details_user_path(@user), alert: @error_message
      return
    end
    redirect_to levels_path
  end

  def ccavenue_cancel_request
    Rails.logger.info params
    begin
      result = Ccavenue::PaymentResponse.new.log_response(params)
    rescue Exception => e
      AdminNotificationMailer.exception_notification(request, current_user, params, e).deliver
    end
    redirect_to enter_subscription_details_user_path(@user)
  end

  private

  def set_user
    @user = current_user
  end

end
