# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Test title 1' }
    description { 'Test description 1' }
    status { 1 }

    trait :with_status_change_record do
      after(:create) do |project, _evaluator|
        if project.status == Projects::StatusTypes[:active]
          action = StatusChangeRecords::ActionTypes[:created_with_active_status]
        elsif Projects::StatusTypes[:inactive]
          action = StatusChangeRecords::ActionTypes[:created_with_inactive_status]
        end

        create(:status_change_record, project: project, action: action)
      end
    end
  end
end
