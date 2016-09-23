module ApplicationHelper
	#defining values for expiration year 
	def expiration_year
    @expiration_year = []
    x = DateTime.now.year.to_i
    for i in x..(x+10)
      @expiration_year << i
    end
  end

  #defining values for expiration month
  def expiration_month
    @months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
  end

  # Set Active class to menu
  def current_path(path)
    "green" if current_page?(path)
  end
end
