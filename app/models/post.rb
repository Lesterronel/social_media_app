class Post < ApplicationRecord
    before_save :set_permalink
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :content, length: { maximum: 1500 }

    private

    def set_permalink
        self.permalink = name.parameterize
    end
end
