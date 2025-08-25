class InvoiceDetail < ApplicationRecord
  belongs_to :invoice
  belongs_to :service
  belongs_to :product
end
