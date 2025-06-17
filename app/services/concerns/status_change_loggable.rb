# frozen_string_literal: true

module StatusChangeLoggable
  extend ActiveSupport::Concern

  included do
    def create_status_change_record(type)
      service = StatusChangeRecords::LogStatusChange.new(@project, type: type)
      service.call
      return if service.errors.blank?

      @status_change_record = service.status_change_record
      raise ActiveRecord::RecordInvalid, @status_change_record
    end
  end
end
