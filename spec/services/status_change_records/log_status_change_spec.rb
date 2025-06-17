# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusChangeRecords::LogStatusChange, type: :model do
  describe '#call' do
    context 'when we have new Project' do
      let(:type) { 'new_record' }

      context 'when we have active project' do
        active_status = 1
        let(:project) do
          create(:project, title: 'Test title 1', status: active_status, description: 'Test description 1')
        end

        it 'creates log status record with correct action' do
          service = described_class.new(project, type: type)
          service.call
          active_status = 1
          expected_action = active_status

          expect(service.status_change_record.action).to eql(expected_action)
        end

        it 'creates one record of StatusChangeRecord class' do
          service = described_class.new(project, type: type)
          service.call

          expect { service.call }.to change(StatusChangeRecord, :count).by(1)
        end
      end

      context 'when we have inactive project' do
        inactive_status = 2
        let(:project) do
          create(:project, title: 'Test title 1', status: inactive_status, description: 'Test description 1')
        end

        it 'creates log status record with correct action' do
          service = described_class.new(project, type: type)
          service.call
          inactive_status = 2
          expected_action = inactive_status

          expect(service.status_change_record.action).to eql(expected_action)
        end
      end
    end

    context 'when we have existing Project' do
      let(:project) do
        create(:project, :with_status_change_record, title: 'Test title 1', status: 1,
                                                     description: 'Test description 1')
      end
      let(:type) { 'existing_record' }

      context 'when status not changed' do
        it 'does not create log status record' do
          service = described_class.new(project, type: type)
          service.call

          expect { service.call }.not_to change(StatusChangeRecord, :count)
        end
      end

      context 'when status got changed' do
        context 'when status changed from active to inactive' do
          active_status = 1
          let(:project) do
            create(:project, :with_status_change_record, title: 'Test title 1', status: active_status,
                                                         description: 'Test description 1')
          end
          let(:type) { 'existing_record' }

          it 'creates log status record with correct action' do
            inactive_status = 2
            project.status = inactive_status
            project.save!

            service = described_class.new(project, type: type)
            service.call
            from_active_status_to_inactive = 3
            expected_action = from_active_status_to_inactive

            expect(service.status_change_record.action).to eql(expected_action)
          end
        end

        context 'when status changed from inactive to active' do
          inactive_status = 2
          let(:project) do
            create(:project, :with_status_change_record, title: 'Test title 1', status: inactive_status,
                                                         description: 'Test description 1')
          end
          let(:type) { 'existing_record' }

          it 'creates log status record with correct action' do
            active_status = 1
            project.status = active_status
            project.save!

            service = described_class.new(project, type: type)
            service.call
            from_inactive_status_to_active = 4
            expected_action = from_inactive_status_to_active

            expect(service.status_change_record.action).to eql(expected_action)
          end
        end
      end
    end
  end
end
