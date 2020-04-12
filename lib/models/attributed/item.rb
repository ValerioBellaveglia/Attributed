module Attributed
  class Item < ActiveRecord::Base
    has_many :lists, class_name: 'Attributed::List', inverse_of: :item, foreign_key: :item_id, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    attr_readonly :name

    before_validation :normalize_name

    def normalize_name
      self.name = self.name.to_s.classify.demodulize
    end
  end
end
