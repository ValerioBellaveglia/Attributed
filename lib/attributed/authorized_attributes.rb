module Attributed
  module AuthorizedAttributes
    extend ActiveSupport::Concern

    def filter_authorized_attributes(attributes, item_name: nil)
      @current_user.authorized_attributes_for_item(item_name.to_s.classify.demodulize || controller_name.singularize).map(&:to_sym).intersection attributes
    end
  end
end

if defined? ActiveSupport
  ActiveSupport.on_load(:action_controller) do
    include Attributed::AuthorizedAttributes
  end
end
