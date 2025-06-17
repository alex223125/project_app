# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::Create, type: :model do
  describe '#call' do
    context 'when we have correct params' do
      let(:project) { create(:project, title: 'Test title 1', status: 1, description: 'Test description 1') }

      it 'creates one record of Project class' do
        params = { 'title' => 'Test title 1', 'status' => '1', 'description' => 'Test description 1' }
        service = described_class.new(params)

        expect { service.call }.to change(Project, :count).by(1)
      end

      it 'creates project with correct title' do
        params = { 'title' => 'Test title 1', 'status' => '1', 'description' => 'Test description 1' }
        service = described_class.new(params)
        service.call

        expect(service.project.title).to eql(project.title)
      end

      it 'creates project with correct description' do
        params = { 'title' => 'Test title 1', 'status' => '1', 'description' => 'Test description 1' }
        service = described_class.new(params)
        service.call

        expect(service.project.description).to eql(project.description)
      end

      it 'creates project with correct project status' do
        params = { 'title' => 'Test title 1', 'status' => '1', 'description' => 'Test description 1' }
        service = described_class.new(params)
        service.call

        expect(service.project.status).to eql(project.status)
      end

      it 'creates status change record' do
        params = { 'title' => 'Test title 1', 'status' => '1', 'description' => 'Test description 1' }
        service = described_class.new(params)

        expect { service.call }.to change(StatusChangeRecord, :count).by(1)
      end
    end

    context 'when we have incorrect params' do
      context 'when one of the parameters is missing' do
        it 'does not create any new project records' do
          params = { 'title' => 'Test title 1', 'status' => '1' }
          service = described_class.new(params)

          expect { service.call }.not_to change(Project, :count)
        end

        it 'does not create any new status change records' do
          params = { 'title' => 'Test title 1', 'status' => '1' }
          service = described_class.new(params)

          expect { service.call }.not_to change(StatusChangeRecord, :count)
        end
      end

      context 'when title is missing in params' do
        it "raises error that title can't be blank when validation fails" do
          params = { 'status' => '1', 'description' => 'Test description 1' }
          service = described_class.new(params)
          service.call

          error_message = "Validation failed: Title can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end

      context 'when status is missing in params' do
        it "raises error that title can't be blank when validation fails" do
          params = { 'title' => 'Test title 1', 'description' => 'Test description 1' }
          service = described_class.new(params)
          service.call

          error_message = "Validation failed: Status can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end

      context 'when description is missing in params' do
        it "raises error that description can't be blank when validation fails" do
          params = { 'title' => 'Test title 1', 'status' => '1' }
          service = described_class.new(params)
          service.call

          error_message = "Validation failed: Description can't be blank"
          expect(service.errors).to eql(error_message)
        end
      end
    end
  end
end
