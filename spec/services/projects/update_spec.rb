# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::Update, type: :model do
  describe '#call' do
    context 'when we have correct params' do
      let(:project) do
        create(:project, :with_status_change_record, title: 'Test title 1', status: 1,
                                                     description: 'Test description 1')
      end

      it 'updates title of Project' do
        params = { title: 'New project title 1', status: 2, description: 'New test description 1' }
        service = described_class.new(project, params)
        service.call

        expect(project.title).to eql(params[:title])
      end

      it 'updates description of Project' do
        params = { title: 'New project title 1', status: 2, description: 'New test description 1' }
        service = described_class.new(project, params)
        service.call

        expect(project.description).to eql(params[:description])
      end

      it 'updates status of Project' do
        params = { title: 'New project title 1', status: 2, description: 'New test description 1' }
        service = described_class.new(project, params)
        service.call

        expect(project.status).to eql(params[:status])
      end

      it 'creates status change record' do
        params = { title: 'New project title 1', status: 2, description: 'New test description 1' }
        service = described_class.new(project, params)

        expect { service.call }.to change(StatusChangeRecord, :count).by(1)
      end
    end

    context 'when we have incorrect params' do
      let(:project) { create(:project, title: 'Test title 1', status: 1, description: 'Test description 1') }

      context 'when one of the parameters is missing' do
        original_project_title = 'Test title 1'
        original_project_status = 1
        original_project_description = 'Test description 1'
        let(:project) do
          create(:project, title: original_project_title, status: original_project_status,
                           description: original_project_description)
        end

        it 'does not update title of existing project' do
          params = { title: 'New project title 1', status: nil, description: 'New test description 1' }
          service = described_class.new(project, params)
          service.call
          project.reload

          expect(project.title).to eql(original_project_title)
        end

        it 'does not update description of existing project' do
          params = { title: 'New project title 1', status: nil, description: 'New test description 1' }
          service = described_class.new(project, params)
          service.call
          project.reload

          expect(project.description).to eql(original_project_description)
        end

        it 'does not update status of existing project' do
          params = { title: 'New project title 1', status: nil, description: 'New test description 1' }
          service = described_class.new(project, params)
          service.call
          project.reload

          expect(project.status).to eql(original_project_status)
        end

        it 'does not create any new status change records' do
          params = { title: 'New project title 1', status: nil, description: 'New test description 1' }
          service = described_class.new(project, params)

          expect { service.call }.not_to change(StatusChangeRecord, :count)
        end
      end

      context 'when title is nil in params' do
        it "raises error that title can't be blank when validation fails" do
          params = { title: nil, status: 1, description: 'New test description 1' }
          service = described_class.new(project, params)
          service.call

          error_message = "Validation failed: Title can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end

      context 'when status is nil in params' do
        it "raises error that title can't be blank when validation fails" do
          params = { title: 'New project title 1', status: nil, description: 'New test description 1' }
          service = described_class.new(project, params)
          service.call

          error_message = "Validation failed: Status can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end

      context 'when description is nil in params' do
        it "raises error that description can't be blank when validation fails" do
          params = { title: 'New project title 1', status: 2, description: nil }
          service = described_class.new(project, params)
          service.call

          error_message = "Validation failed: Description can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end
    end
  end
end
