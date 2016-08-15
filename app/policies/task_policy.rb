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

  def create?
    user_is_admin_or_owns_task
  end

  def update?
    user_is_admin_or_owns_task
  end

  def destroy?
    user_is_admin_or_owns_task
  end

  def download_attachment?
    user_is_admin_or_owns_task
  end

  private

  def user_is_admin_or_owns_task
    user_owns_task? || @user.admin?
  end

  def user_owns_task?
    @task.user_id == @user.id
  end

end
