module Site
  class HomeController < SiteController
    skip_before_action :authenticate_user!
    
    def index
      # if current_user
      #   @active_posts = Post.where(active: true, featured: false).where("publish_date <= ?", Date.today).where("user_id = ?", current_user.id).order("publish_date desc")
      #   @featured_posts = Post.where(active: true, featured: true).where("publish_date <= ?", Date.today).order("publish_date desc").limit(5)
      # else 
      #   @active_posts = Post.where(active: true, featured: false).where("publish_date <= ?", Date.today).order("publish_date desc")
      #   @featured_posts = Post.where(active: true, featured: true).where("publish_date <= ?", Date.today).order("publish_date desc").limit(5)
      # end
      @active_posts = Post.where(active: true, featured: false).where("publish_date <= ?", Date.today).order("publish_date desc")
      @featured_posts = Post.where(active: true, featured: true).where("publish_date <= ?", Date.today).order("publish_date desc").limit(5)
    end
  end
end
