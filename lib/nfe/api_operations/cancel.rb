module Nfe
  module ApiOperations
    module Cancel
      def cancel(nfe_id)
        method = :delete
        response = api_request("#{url}/#{nfe_id}", method)
        create_from(response)
      end

      def self.included(base)
        base.extend(Cancel)
      end
    end
  end
end
