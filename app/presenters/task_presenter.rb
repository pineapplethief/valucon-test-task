class TaskPresenter < BasePresenter

  def created_at
    h.l(super)
  end

  def render_list_attribute(attribute)
    h.content_tag(:div, class: "task-attribute task-attribute-#{attribute}") do
      h.concat "#{Task.human_attribute_name(attribute)}: "
      h.concat h.content_tag(:strong, send(attribute), class: "qa-task-#{attribute}")
    end
  end

end
