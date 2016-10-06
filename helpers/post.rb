require 'time'
require "yaml"

class Post
  attr_accessor :attr, :src_path, :dest_path

  def initialize(hash, src_path)
    @attr = hash
    @src_path = src_path
  end

  def title
    @attr["title"] || ""
  end

  def created_at
    temp = @attr["date"] || @attr["created_at"] || ""
    to_date(temp)
  end

  def updated_at
    temp = @attr["updated_at"] || ""
    to_date(temp, created_at)
  end

  def to_date(str, default_date = Time.now)
    if str.empty?
      default_date
    else
      Time.parse(str)
    end
  end

  def category
    @attr["category"] || @attr["categories"] || "undefined"
  end

  def tags
    temp = @attr["tags"] || "undefined"
    if temp.is_a?(String)
      [temp]
    else
      temp
    end
  end

  def html_path
    html_href
  end

  def html_href
    File.join(File.basename(@src_path)).gsub(" ", "_").sub(/.(\w+)$/, ".html")
  end

  def to_link
    %Q{[#{title}](#{html_href})}
  end
end

module PostParser
  def parse(file)
    cnt = 0
    lines = []
    file.each do |line|
      if /^---/ === line
        cnt += 1
      elsif cnt == 1
        lines << line
      elsif cnt >= 2
        break
      else
        # nop
      end 
    end
    YAML::load(lines.join("\n")) unless lines.empty?
  end
end


module PostBuilder
  include PostParser

  def build_from_file(file)
    hash = parse(file)
    unless hash.empty?
      Post.new(hash, File.absolute_path(file))
    else
      puts File.absolute_path(file)
    end
  end
end