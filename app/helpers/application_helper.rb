module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then 'alert-success'
    when :error then 'alert-danger'
    when :alert then 'alert-warning'
    end
  end

  def task_button_class()
  end

  def icon_tag(name)
    content_tag(:span, nil, class: "glyphicon glyphicon-#{name}", aria: {hidden: "true"})
  end

  def close_button_tag(options = {})
    options.reverse_merge!({
      type: 'button',
      class: 'close',
      data: {dismiss: 'alert'},
      aria: {label: 'Close'}
    })
    content_tag :button, options do
      content_tag :span, aria: {hidden: 'true'} do
        '&times;'.html_safe
      end
    end
  end
end
