# Change the behavior of fields with bad data. This adds a data-errors
# attribute to the tag with the errors. JavaScript then creates the appropriate
# visual error display.

def _escape_utf8(string)
  string.gsub(/([\u007F-\uFFFF])/) { |char| "\\u#{char.unpack1('U*').to_s(16).rjust(4, '0')}" }
end

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag.start_with?('<label')
    html_tag
  else
    tag                = Nokogiri::HTML.fragment(html_tag).children.first
    tag['data-errors'] = URI.encode_www_form_component(_escape_utf8(instance.error_message.to_json)).chomp
    tag.to_html.html_safe
  end
end
