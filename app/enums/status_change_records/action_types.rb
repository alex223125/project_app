# frozen_string_literal: true

module StatusChangeRecords
  class ActionTypes < ActiveEnum::Base
    value id: 1, name: 'created_with_active_status', text: 'Created with active status'
    value id: 2, name: 'created_with_inactive_status', text: 'Created with inactive status'
    value id: 3, name: 'from_active_to_inactive', text: 'Status changed from active to inactive'
    value id: 4, name: 'from_inactive_to_active', text: 'Status changed from inactive to active'
  end
end
