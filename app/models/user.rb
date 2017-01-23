class User < ActiveRecord::Base
  
  def create_payment_interaction_with_cc_avenue_request_params
    pg_transaction = self.payment_interactions.create
    pg_transaction.request_params = Ccavenue::Payment.new(self, pg_transaction).request_params
    pg_transaction.save!
    pg_transaction
  end
end
