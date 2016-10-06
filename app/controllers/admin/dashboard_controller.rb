class Admin::DashboardController < Admin::BaseController
	def index
    @user_count = User.where(:user_type => 3).count
    @reviewer_count = User.where(:user_type => 2).count
    @order_count = Order.all.count
    @video_approval_count = Order.where(:status => Order::STATUS["Reviewed"]).count
	end
end