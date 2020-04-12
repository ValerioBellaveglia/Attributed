module Attributed
  module AuthorizedAttributes
    extend ActiveSupport::Concern

    def filter_authorized_attributes(attributes, item_name)
      @current_user.authorized_attributes_for_item(item_name).map(&:to_sym).intersection attributes
    end
  end
end

if defined? ActiveSupport
  ActiveSupport.on_load(:action_controller) do
    include Attributed::AuthorizedAttributes
  end
end
