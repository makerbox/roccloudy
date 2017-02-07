class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, product)
	# if Discount.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)
		if Discount.where(producttype: 'group_percent', product: product.group, customertype: 'code_percent', customer: user.account.code).exists?
			discount = Discount.where(producttype: 'group_percent', product: product.group, customertype: 'code_percent', customer: user.account.code).discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'group_percent', product: product.group, customertype: 'group_percent', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'group_percent', product: product.group, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: product.code, customertype: 'code_percent', customer: user.account.code).exists?
			discount = Discount.where(producttype: 'code_percent', product: product.code, customertype: 'code_percent', customer: user.account.code)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: product.code, customertype: 'group_percent', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'code_percent', product: product.code, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
	# elsif Discount.where(producttype: 'group_fixed', product: product.group, customertype: 'code_fixed', customer: user.account.code)
		elsif Discount.where(producttype: 'group_fixed', product: product.group, customertype: 'code_fixed', customer: user.account.code).exists?
			discount = Discount.where(producttype: 'group_fixed', product: product.group, customertype: 'code_fixed', customer: user.account.code)[0].discount
			price - discount
		elsif Discount.where(producttype: 'group_fixed', product: product.group, customertype: 'group_fixed', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'group_fixed', product: product.group, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: product.code, customertype: 'code_fixed', customer: user.account.code).exists?
			discount = Discount.where(producttype: 'code_fixed', product: product.code, customertype: 'code_fixed', customer: user.account.code)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: product.code, customertype: 'group_fixed', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'code_fixed', product: product.code, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		# end
		else
			price - 1
		end
end

end #end of class
