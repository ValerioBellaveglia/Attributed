module Attributed
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :attributes_lists, class_name: 'Attributed::AttributesList', as: :attributable, dependent: :destroy
    end

    module ClassMethods
      def attributed_through(association)
        has_many :attributes_lists, through: association, class_name: 'Attributed::AttributesList', source: :attributes_lists
      end
    end

    def authorized_attributes_for_item(item_name)
      attributes_lists.for_item(item_name).map(&:authorized_attributes).flatten.map(&:to_s).uniq
    end

    def grant_all_for(*item_names)
      item_names.each do |item_name|
        item_name = item_name.to_s.classify.demodulize
        item_class = Attributed::AttributesList.reflections["item"].options[:class_name].constantize

        attributes_list = attributes_lists.for_item(item_name).take || attributes_lists.create!(item: item_class.find_or_create_by!(name: item_name))
        attributes_list.grant_all
      end
    end
  end
end
