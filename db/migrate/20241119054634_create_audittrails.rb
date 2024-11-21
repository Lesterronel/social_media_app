class CreateAudittrails < ActiveRecord::Migration[8.0]
  def change
    create_table :audittrails do |t|
      t.string :module
      t.string :event_type
      t.text :current_data
      t.text :old_data
      t.text :data_differences
      t.inet :ip_address
      t.string :modified_by_email
      t.string :modified_by_name

      t.timestamps
    end
  end
end
