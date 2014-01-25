# Works with config/initializers/field_error_proc.rb to properly stylize form
# fields with errors.

$(document).ready ->
  escape = (str) -> str.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')

  $('[data-errors]').each (_, span) ->
    element = $(span)
    errors = JSON.parse(unescape(element.attr('data-errors')))
    element.parents('.form-group').addClass('has-error')
    element.tooltip
      title: (escape(error) for error in errors).join("<br/>")
      placement: 'right'
      trigger: 'focus'
      template: '<div class="tooltip tooltip-error"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
