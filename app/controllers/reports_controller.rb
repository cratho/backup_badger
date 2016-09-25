# Class to do some basic reporting
class ReportsController < ApplicationController
  def index
    @num_transactions = 20
    @transactions = Transaction.order(:created_at).last(
      @num_transactions
    )
  end
end
