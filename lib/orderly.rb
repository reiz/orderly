require "orderly/version"
require "rspec/expectations"

module Orderly
  RSpec::Matchers.define :appear_before do |later_content|
    match do |earlier_content|
      begin
        node = page.respond_to?(:current_scope) ? page.current_scope : page.send(:current_node)
        html = html_for_node(node)
        html.index(earlier_content) < html.index(later_content)
      rescue ArgumentError
        raise "Could not locate later content on page: #{later_content}"
      rescue NoMethodError
        raise "Could not locate earlier content on page: #{earlier_content}"
      end
    end

    def html_for_node(node)
      if node.is_a?(Capybara::Node::Document)
        page.body
      elsif node.native.respond_to?(:inner_html)
        node.native.inner_html
      else
        page.driver.evaluate_script("arguments[0].innerHTML", node.native)
      end
    end
  end
end
