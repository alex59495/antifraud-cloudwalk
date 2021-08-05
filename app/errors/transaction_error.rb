module TransactionError
  class TransactionAlreadyExists < StandardError
    def message
      "The transaction already exists"
    end
  end

  class CustomerEmpty < StandardError
    def message
      "User field isn't filled or doesn't exist, please correct the request"
    end
  end

  class MerchantEmpty < StandardError
    def message
      "Merchant field isn't filled or doesn't exist, please correct the request"
    end
  end

  class TransactionEmpty < StandardError
    def message
      "Transaction field isn't filled, please correct the request"
    end
  end
end
