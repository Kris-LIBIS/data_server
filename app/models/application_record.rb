class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.update_or_create(args, attributes)
    obj = self.find_or_create_by(args)
    obj.update(attributes)
    obj.save!
    obj
  end

end
