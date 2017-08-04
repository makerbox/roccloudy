class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)
	
	# if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code || u.account.discount))
		# FOR SOME REASON CHANGING THE ORDER OF THE 'price_cat || prod_code || prod_group' WORKS? THIS COULD MEAN SOMETHING ELSE IS WRONG
		# discos = (Discount.all.where(product: price_cat , customer: u.account.code)) || (Discount.all.where(product: prod_code , customer: u.account.code)) || (Discount.all.where(product: prod_group , customer: u.account.code)) || (Discount.all.where(product: price_cat , customer: u.account.discount)) || (Discount.all.where(product: prod_code , customer: u.account.discount)) || (Discount.all.where(product: prod_group , customer: u.account.discount))
	if discos = Discount.all.where('product = ? OR product = ? OR product = ?', price_cat , prod_code , prod_group).where('customer = ? OR customer = ?', u.account.code, u.account.discount)
		if disco = discos.where('maxqty >= ?', 1).first			
		    if disco.disctype == 'fixedtype'
		      result =  disco.discount
		    else
		      result = 1
		    end
		else
			result = price
		end
	else
		result = price
	end

	return result
end




end #end of class
