class TaskPresenter < BasePresenter

  def created_at
    h.l(super)
  end

  def state
    h.t("task.states.#{super}")
  end

  def state_button(state_event)
    can_transition = send(:"may_#{state_event}?")
    button_css =
      case state_event
      when :start
        'btn-primary'
      when :finish
        'btn-success'
      when :reset
        'btn-warning'
      end
    text = h.t("task.events.#{state_event}")
    text_css = "task-state-link task-state-link-#{state_event}"

    h.content_tag(:button, class: "task-btn btn btn-lg #{button_css}",
                           data: {event: state_event, id: id},
                           type: 'button') do
      if can_transition
        h.link_to text, '#', class: text_css
      else
        h.content_tag(:span, text, class: text_css)
      end
    end
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
