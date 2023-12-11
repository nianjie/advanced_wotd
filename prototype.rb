# frozen_string_literal: true

require 'rss'
require 'open-uri'

url = 'https://merriam-webster.com/wotd/feed/rss2'

def find_non_empty_props(item)
  item.instance_variables.filter do |name|
    value = item.instance_variable_get name
    (value.respond_to? :empty?) ? !value&.empty? : value
  end
end

non_empty_props = [:title, :link, :description, :encolsure, :pubDate, :itunes_summary, :itunes_duration]

URI.open(url) do |rss|
  feed = RSS::Parser.parse rss
  props = find_non_empty_props(feed.items[0])
  feed.items.each_with_index do |item, i|
    puts "Item: #{i}"
    props.each do |name|
      puts "#{name} : #{item.instance_variable_get name}"
    end
    puts "-" * 20
  end
end
