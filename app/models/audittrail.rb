class Audittrail < ApplicationRecord
  before_save :format_data

  def administrator
    Administrator.find_by(email: self.modified_by_email)
  end

  private
    def format_data
      self.current_data = self.current_data&.gsub('=&gt', ':')
      self.old_data = self.old_data&.gsub('=&gt', ':')
      self.data_differences = self.old_data&.gsub('=&gt', ':')
    end
end
