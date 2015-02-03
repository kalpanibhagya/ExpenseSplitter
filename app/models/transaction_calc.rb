class TransactionCalc
	attr_accessor :user, :portion, :put, :pay
	
	def new
		@user = nil
		@portion = 0.0
		@put = 0.0
		@pay = 0.0
	end
end
