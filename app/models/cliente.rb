class Cliente < ApplicationRecord
    validates :nombre, :apellido, :identificacion, presence: true
end
