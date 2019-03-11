class UserDocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def show?
    record.user == user
  end

  def update?
    record.user == user
  end

  def pay?
    update?
  end

  def unpaid?
    update?
  def destroy?
    record.user == user
  end
end
end
