class TaskPresenter < BasePresenter

  def created_at
    h.l(super)
  end

  def state
    h.t("task.states.#{super}")
  end

  def render_description
    h.content_tag(:div, class: "task-attribute task-attribute-description") do
      h.concat h.content_tag(:strong, "#{Task.human_attribute_name(:description)}: ")
      h.concat h.content_tag(:p, description, class: 'qa-task-description')
    end
  end

  def render_list_attribute(attribute)
    h.content_tag(:div, class: "task-attribute task-attribute-#{attribute}") do
      h.concat h.content_tag(:strong, "#{Task.human_attribute_name(attribute)}: ")
      h.concat h.content_tag(:span, send(attribute), class: "qa-task-#{attribute}")
    end
  end

end
