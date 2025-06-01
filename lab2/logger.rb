module Logger
  def self.log_info(msg)
    File.write("app.logs", "#{Time.now} -- info -- #{msg}\n", mode: "a")
  end

  def self.log_warning(msg)
    File.write("app.logs", "#{Time.now} -- warning -- #{msg}\n", mode: "a")
  end

  def self.log_error(msg)
    File.write("app.logs", "#{Time.now} -- error -- #{msg}\n", mode: "a")
  end
end

class User
    attr_accessor :name, :balance

    def initialize(name, balance)
      @name = name
      @balance = balance
    end
end 

class Transaction
    attr_reader :user, :value

    def initialize(user, value)
      @user = user
      @value = value
    end
end 

class Bank 
  def initialize()
    raise "#{self.class} is abstract" if self.instance_of?(Bank)
  end

  def self.process_transactions(transactions, &block)
    raise "Method #{__method__} is abstract, please override this method"
  end
end

class CBABank < Bank
  include Logger 

  @@users = [
    User.new("Ali", 200),
    User.new("Peter", 500),
    User.new("Manda", 100)
  ]

  def self.process_transactions(transactions, block)
    msg = transactions.map { |transaction| "Processing Transactions: User #{transaction.user.name} transaction with value #{transaction.value}" }
    Logger.log_info(msg.join(", "))

    transactions.each do |transaction|
      status = true
      reason = nil

      begin
        index = @@users.find_index { |user| user.name == transaction.user.name }

        if index  # User exists in the bank
            if transaction.value.abs <= @@users[index].balance
                @@users[index].balance += transaction.value
                msg = "User #{transaction.user.name} transaction with value #{transaction.value} succeeded"
                Logger.log_info(msg)

                if @@users[index].balance == 0
                    msg = "User #{transaction.user.name} now has #{@@users[index].balance} balance"
                    Logger.log_warning(msg)
                end
            elsif transaction.value.abs > @@users[index].balance
                raise "Not enough balance"
            else
                msg = "User #{transaction.user.name} transaction with value #{transaction.value} failed with message Not enough balance"
                Logger.log_error(msg)
                status = false
                reason = "Not enough balance"
            end
        else  # User does not exist
            msg = "User #{transaction.user.name} transaction with value #{transaction.value} failed with message #{transaction.user.name} does not exist in the bank!"
            Logger.log_error(msg)
            status = false
            reason = "#{transaction.user.name} does not exist in the bank!"
        end

        block.call(status, transaction.user.name, transaction.value, reason)
      rescue => e
        Logger.log_error("Transaction failed for User #{transaction.user.name}: #{e.message}")
        block.call(false, transaction.user.name, transaction.value, e.message)
      end

    end
  end
end


# Logger.log_info("olla")

users = [
    User.new("Ali", 200),
    User.new("Peter", 500),
    User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -60),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

my_proc = proc { |status,name,value,reason|
    if status
        puts "Call endpoint for success of User #{name} transaction with value #{value}"
    else
        puts "Call endpoint for failure of User #{name} transaction with value #{value} with reason #{reason}"
    end
}

CBABank.process_transactions(transactions, my_proc)