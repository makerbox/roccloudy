class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)

	
	if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code || u.account.discount))
		if disco = discos.where('maxqty >= ?', qty).first
		    if disco.disctype == 'fixedtype'
		      result =  disco.discount
		    else
		      result = price - ((price / 100) * disco.discount)
		    end
		else
			result = 1
		end
	else
		result = 2
	end
	if u.account.code == 'JOHN LUK'
		result = 4
	else
		result = 5
	end
	return result
end




end #end of class
