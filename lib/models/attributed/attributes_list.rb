module Attributed
  class AttributesList < ActiveRecord::Base
    belongs_to :item
    belongs_to :attributable, polymorphic: true

    serialize :authorized_attributes, Array

    scope :for_item, -> (item_name) { joins(:item).where(items: { name: item_name.to_s.demodulize.classify }) }

    validates_uniqueness_of :item_id, scope: %i[attributable_id attributable_type]

    def authorized_attributes
      super.map { |attribute| attribute.to_s.downcase }
    end

    def grant_all(item_class: nil, except: [])
      authorized_attributes = ((self.authorized_attributes || []) + (item_class || item.name.classify.constantize).column_names).uniq
      authorized_attributes = authorized_attributes.reject { |authorized_attribute| authorized_attribute.in? except } if except.any?

      update authorized_attributes: authorized_attributes
    rescue NameError
      raise 'Provided item name does not match with any defined class: specify a valid "item_class" option.'
    end
  end
end
