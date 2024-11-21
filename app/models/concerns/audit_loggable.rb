module AuditLoggable
  extend ActiveSupport::Concern
  include ActionView::Helpers::SanitizeHelper
  included do
    after_create :log_creation
    after_update :log_update
    before_destroy :log_deletion
    # This class variable will help prevent recursive calls
    class << self
      attr_accessor :logging_enabled
    end

    def current_actor
      if Thread.current[:current_administrator]
        Thread.current[:current_administrator]
      elsif Thread.current[:current_user]
        Thread.current[:current_user]
      else
        'System' # Fallback value if no session is set
      end
    end

    def log_creation
      log_to_audittrail('add', self.class.name&.titleize.pluralize, current_actor)
    end
    def log_update
      log_to_audittrail('edit', self.class.name&.titleize.pluralize, current_actor)
    end
    def log_deletion
      log_to_audittrail('delete', self.class.name&.titleize.pluralize, current_actor)
    end
    private
    def log_to_audittrail(action, moduletype, user)
      return unless user
      return if self.class.logging_enabled
      self.class.logging_enabled = true # Set logging flag to true to prevent recursive logging
      audittrail                   = Audittrail.new
      audittrail.module            = moduletype
      audittrail.ip_address        = ""
      audittrail.modified_by_email = user.email
      audittrail.modified_by_name  = "No name"
      case action
      when 'add'
        audittrail.event_type = 'Create'
        audittrail.current_data = strip_tags(
          attributes.except(
            "created_at",
            "updated_at",
            "encrypted_password",
            "reset_password_token"
          ).to_s
        )
      when 'edit'
        audittrail.event_type = 'Update'
        # Extract the old data (before update) and current data (after update)
        old_data = previous_changes.transform_values(&:first).except(
          "updated_at",
          "encrypted_password",
          "reset_password_token"
        )
        new_data = attributes.except(
          "created_at",
          "updated_at",
          "encrypted_password",
          "reset_password_token"
        )
        differences = previous_changes.except(
          "updated_at",
          "encrypted_password",
          "reset_password_token"
        )
        audittrail.old_data = strip_tags(old_data.to_s)
        audittrail.current_data = strip_tags(new_data.to_s)
        audittrail.data_differences = strip_tags(differences.to_s)
      when 'delete'
        audittrail.event_type = 'Delete'
        audittrail.current_data = strip_tags(
          attributes.except(
            "updated_at",
            "encrypted_password",
            "reset_password_token"
          ).to_s
        )
      end
      audittrail.save
    ensure
      self.class.logging_enabled = false # Reset logging flag
    end
  end
end