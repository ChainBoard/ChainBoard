# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title)
    base_title = 'CojtBoardProject' # アプリ名
    if page_title.empty?
      base_title
    else
      "#{page_title}   #{base_title}"
    end
  end

  def comment_body_format(body)
    body_lines = body.split(/\r\n/).map.with_index do |line, index|
      if index.zero?
        line
      else
        tag.br + line
      end
    end

    body_lines.inject(raw('')) do |res, line|
      res + line
    end
  end
end
