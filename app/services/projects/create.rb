# frozen_string_literal: true

module Projects
  class Create
    include StatusChangeLoggable

    PROJECT_RECORD_TYPE = 'new_record'

    attr_reader :errors, :project, :status_change_record

    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        create_project
        @project.save!
        create_status_change_record(PROJECT_RECORD_TYPE)
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
        Rails.logger.error(@errors)
      end
    end

    private

    def create_project
      @project = Project.new(@params)
    end
  end
end
