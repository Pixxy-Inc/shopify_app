module ShopifyApp
  module SessionStorage
    extend ActiveSupport::Concern

    def with_shopify_session(&block)
      ShopifyAPI::Session.temp(shopify_domain, shopify_token, &block)
    end

    class_methods do
      def store(session)
        shop = self.find_or_initialize_by(shopify_domain: session.url)
        shop.shopify_token = session.token
        shop.save!
        shop.id
      end

      def retrieve(id)
        return unless id

        if shop = self.find_by(id: id)
          ShopifyAPI::Session.new(domain: shop.shopify_domain, token: shop.shopify_token, api_version:'2020-01')
        end
      end
    end

  end
end
