module TransactionError
  class TransactionAlreadyExists < StandardError
    def message
      "The transaction already exists"
    end
  end

  class CustomerError < StandardError
    def message
      "User field isn't filled or doesn't exist, please correct the request"
    end
  end

  class MerchantError < StandardError
    def message
      "Merchant field isn't filled or doesn't exist, please correct the request"
    end
  end

  class FraudError < StandardError
    def message
      "We noticed that this transaction might be a fraud, the transaction was cancelled. Contact your bank for futher information"
    end
  end

  class FraudErrorScore < StandardError
    def message
      "The score fraud is too high, the transaction couldn't be completed "
    end
  end
end
