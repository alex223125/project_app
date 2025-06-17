# frozen_string_literal: true

module Projects
  class Update
    include StatusChangeLoggable

    PROJECT_RECORD_TYPE = 'existing_record'

    attr_reader :errors, :project

    def initialize(project, params)
      @project = project
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        update_project
        @project.save!
        create_status_change_record(PROJECT_RECORD_TYPE)
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
        Rails.logger.error(@errors)
      end
    end

    private

    def update_project
      @project.assign_attributes(@params)
    end
  end
end
