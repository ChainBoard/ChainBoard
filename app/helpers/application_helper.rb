# frozen_string_literal: true

module ApplicationHelper
  def page_title(page_title)
    base_title = 'ChainBoard'
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def comment_body_format(body)
    raw(html_escape(body)
            .gsub(/#([^#\p{Space}]+)/, tag.a('#\1', href: root_path(body: '\1').gsub(/%5C/, '%23\\')))
            .gsub(/\r\n/, tag.br))
  end
end
