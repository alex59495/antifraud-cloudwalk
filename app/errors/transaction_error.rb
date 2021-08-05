module TransactionError
  class TransactionAlreadyExists < StandardError
    def message
      "The transaction already exists"
    end
  end
end
