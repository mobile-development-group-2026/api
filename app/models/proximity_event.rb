class ProximityEvent < ApplicationRecord
  belongs_to :student, class_name: "User", optional: true
  belongs_to :listing, optional: true
end
