class Building < ApplicationRecord
  has_paper_trail only: [:manager_name]
end
