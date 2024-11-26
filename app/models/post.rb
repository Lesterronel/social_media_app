class Post < ApplicationRecord
    include AuditLoggable
    include Filterable

    acts_as_votable

    before_save :set_permalink
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :content, presence: true, length: { maximum: 1500 }
    validates :publish_date, presence: true
    belongs_to :user
    has_many :comment

    # scopes for admin search and sorting
    scope :for_datatables, -> { select(:id, :name, :content, :publish_date, :active, :featured, :permalink, :user_id) }
    scope :filter_by_email, ->(email) { joins(:user).where("users.email ILIKE ?", "%#{email}%") }
    scope :filter_by_search_string, ->(search_string) { where("name ILIKE ?", "%#{search_string}%").or(where("content ILIKE ?", "%#{search_string}%")) }
    scope :filter_by_active, ->(active) { where("active = ?", "#{active}") }
    scope :filter_by_featured, ->(featured) { where("featured = ?", "#{featured}") }
    scope :filter_by_publish_date, ->(date_from, date_to) do
        where("publish_date BETWEEN ? AND ?", date_from, date_to) if date_from.present? && date_to.present?
      end
    scope :order_by_column, ->(sort_column, sort_direction) { joins(:user).order(Arel.sql("#{sort_column} #{sort_direction}")) }
    # end

    private

    def set_permalink
        self.permalink = name.parameterize
    end
end
