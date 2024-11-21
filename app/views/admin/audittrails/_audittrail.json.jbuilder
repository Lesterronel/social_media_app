json.extract! audittrail, :id, :module, :event_type, :current_data, :old_data, :data_differences, :ip_address, :modified_by_email, :modified_by_name, :created_at, :updated_at
json.url audittrail_url(audittrail, format: :json)
