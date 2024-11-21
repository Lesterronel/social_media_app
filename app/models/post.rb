class Post < ApplicationRecord
    include AuditLoggable
    include Filterable

    before_save :set_permalink
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :content, length: { maximum: 1500 }
    belongs_to :user

    scope :for_datatables, -> { select(:id, :name, :content, :publish_date, :active, :featured, :permalink, :user_id) }

    scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
    scope :filter_by_active, ->(active) { where("active = ?", "#{active}") }

    private

    def set_permalink
        self.permalink = name.parameterize
    end
end
