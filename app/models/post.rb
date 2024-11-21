class Post < ApplicationRecord
    include AuditLoggable

    before_save :set_permalink
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :content, length: { maximum: 1500 }
    belongs_to :user

    private

    def set_permalink
        self.permalink = name.parameterize
    end
end
