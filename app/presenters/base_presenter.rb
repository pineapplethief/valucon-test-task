class BasePresenter
  delegate :url_helpers, to: :"Rails.application.routes"
  alias_method :urls, :url_helpers

  # Needed for form builders to work properly
  def self.model_name
    to_s.split('Presenter').first.constantize.model_name
  end

  attr_reader :model, :view_context

  def initialize(model, view_context)
    @model = model
    @view_context = view_context
  end

  def h
    @view_context
  end

  def method_missing(method, *args)
    super unless model.respond_to?(method)

    value = model.send(method, *args)
    value
  end

  def respond_to_missing?(method_name, include_private = false)
    model.respond_to?(method_name, include_private) || super
  end

  # needed to make transparent equality comparisons on AR models, e.g.:
  # UserPresenter.new(user) == user
  def instance_of?(klass)
    model.class == klass
  end

  def ==(other)
    other.respond_to?(:present) ? model == other.model : model == other
  end

  # cleaner inspect output
  def inspect
    "#<#{self.class}:0x#{(object_id << 1).to_s(16)}, @model=#{model.inspect}"
  end

end
