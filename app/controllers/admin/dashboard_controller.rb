class Admin::DashboardController < AdminController
  def index
    @active_posts = Post.where(active: true, featured: false).where("publish_date <= ?", Date.today).order("publish_date desc")
    @featured_posts = Post.where(active: true, featured: true).where("publish_date <= ?", Date.today).order("publish_date desc")
  end
end
