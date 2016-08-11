class ApplicationPolicy
  class Scope
    attr_reader :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' if user.guest?

    @user = user
    @record = record
  end

  def scope
    klass = @record.class.to_s.include?('Presenter') ? @record.model_name.name.constantize : @record.class
    Pundit.policy_scope!(@user, klass)
  end

  def index?
    false
  end

  def show?
    scope.where(id: @record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end
