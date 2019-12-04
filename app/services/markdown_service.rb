# frozen_string_literal: true

require 'kramdown'

class MarkdownService
  def self.render(text)
    return if text.blank?
    Kramdown::Document.new(text).to_html
  end
end