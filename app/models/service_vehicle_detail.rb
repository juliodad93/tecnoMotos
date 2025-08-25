class ServiceVehicleDetail < ApplicationRecord
  belongs_to :service
  belongs_to :vehicle
end
