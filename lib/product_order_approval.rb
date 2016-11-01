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
         },
        {
          can: true,
          callback_name: 'can_bypass_order_approvals',
          name: 'Can bypass Order Approvals'
        }
      ]
    end
  end

  module Authorization
    module Permissions

      def can_bypass_order_approvals
        can :bypass_order_approvals, Order
      end

      def can_manage_product_order_holds
        ids = @user.claims.for_site(@site).pluck(:id)
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
