class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index
  end

  def show
    true
  end

  def create
    user == record.user
  end
end
