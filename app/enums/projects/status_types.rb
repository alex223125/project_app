module Projects
  class StatusTypes < ActiveEnum::Base
    value :id => 1, :name => 'active'
    value :id => 2, :name => 'inactive'
  end
end