class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def kfi
  	filename = self.id.to_s + self.user.account.company
  	path = "E:\\Attache\\Attache\\Roc\\KFIDATA\\Orders\\" + filename + ".kfi"
  	items = []
  	self.quantities.each do |q|
  		product = q.product.code.to_s
  		qty = q.qty.to_s
  		items << '"'+product+'","'+qty+'","","","",""'
  	end
  	notes1 = self.notes[0,60]
    len = self.notes.length
    notes2 = self.notes[60,len]
  	firstline = '"'+self.user.account.company+'","","","","","","","'+filename+'","","'+self.order_number.to_s+'","","","",""
  	'
    lastline = '<F9><F4><DOWN><DOWN><DOWN><DOWN><ENTER>,"","","'+notes1+'","","'+notes2+'","","","","","","","","","","",""'
  	File.open(path, "w+") do |f|
  		f.puts(firstline)
      items.each do |i|
        f.puts(i)
      end
      f.puts(lastline)
  	end
  end

end
