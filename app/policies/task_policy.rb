class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.admin?
        scope.all
      elsif @user.user?
        scope.for_user(@user)
      else
        scope.none
      end
    end
  end

  attr_reader :task

  def initialize(user, task)
    @task = task
    super
  end

end
