module Spree
  module Admin
    SearchController.class_eval do
      def addresses
        if params[:q]
          @user = Spree::User.find params[:q]
        end
      end
    end
  end
end