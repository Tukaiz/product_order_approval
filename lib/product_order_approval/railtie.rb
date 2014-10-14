module ProductOrderApproval
  class Railtie < Rails::Railtie

    initializer "my_railtie.configure_rails_initialization" do |app|
      FeatureBase.register(app, ProductOrderApproval)
      FeatureBase.register_autoload_path(app, "product_order_approval")
    end

    config.after_initialize do
      FeatureBase.inject_feature_record("Product Order Approval",
        "ProductOrderApproval",
        "Products can be flagged as needing approval from any group/claim.  Anyone who orders the product will need approval."
      )
      FeatureBase.inject_permission_records(
        ProductOrderApproval,
        ProductOrderApprovalFeatureDefinition.new.permissions
      )
    end

  end
end
