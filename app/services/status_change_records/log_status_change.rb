# frozen_string_literal: true

module StatusChangeRecords
  class LogStatusChange
    CHANGES_IN_STATUS_ACTION_TYPES_MAPPING = { active: 'from_inactive_to_active',
                                               inactive: 'from_active_to_inactive' }.freeze
    NEW_PROJECT_ACTION_TYPES_MAPPING = { active: 'created_with_active_status',
                                         inactive: 'created_with_inactive_status' }.freeze

    attr_reader :errors, :status_change_record

    def initialize(project, type:)
      @project = project
      @type = type
    end

    def call
      ActiveRecord::Base.transaction do
        return if status_not_changed?

        create_status_change_record
        @status_change_record.save!
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
        Rails.logger.error(@errors)
      end
    end

    private

    def status_not_changed?
      return false unless @type == 'existing_record'

      last_change_in_status_id = @project.status_change_records.last.action
      last_change_in_status = StatusChangeRecords::ActionTypes[last_change_in_status_id]
      last_status = statuses.select { |status| status[1] == last_change_in_status }.first[0]

      current_status = Projects::StatusTypes[@project.status].to_sym
      current_status == last_status
    end

    def statuses
      CHANGES_IN_STATUS_ACTION_TYPES_MAPPING.to_a + NEW_PROJECT_ACTION_TYPES_MAPPING.to_a
    end

    def create_status_change_record
      status = Projects::StatusTypes[@project.status].to_sym
      action = define_action(status)
      @status_change_record = @project.status_change_records.new(action: StatusChangeRecords::ActionTypes[action])
    end

    def define_action(status)
      if @type == 'new_record'
        NEW_PROJECT_ACTION_TYPES_MAPPING[status]
      elsif @type == 'existing_record'
        CHANGES_IN_STATUS_ACTION_TYPES_MAPPING[status]
      end
    end
  end
end
