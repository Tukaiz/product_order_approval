require "product_order_approval/version"

module ProductOrderApproval

  class ProductOrderApprovalFeatureDefinition
    include FeatureSystem::Provides
    def permissions
      [
         {
          can: true,
          callback_name: 'can_manage_product_order_holds',
          name: 'Can Manage Product Order Approvals'
         }
      ]
    end
  end

  module Authorization
    module Permissions

      def can_manage_product_order_holds
        UserEditContext.call(@user, @site)
        ids = @user.full_claims.pluck(:id)
        ## Can view the approvals section
        can :view_order_approval_section, Order

        ## Can read any order for which there is at least 1 order_hold that needs approval
        can :read, Order, id: Order.for_approvals(ids).pluck(:id)

        can :manage, OrderHold
      end

    end
  end

end

require 'product_order_approval/railtie' if defined?(Rails)
