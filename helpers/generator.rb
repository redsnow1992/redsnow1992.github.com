require_relative "./common.rb"
require_relative "./params.rb"
require "fileutils"

module Generator
  include Common

  def create_index_file(posts)
    filename = File.join(Params::POSTS_HOME, "index.Rmd")
    File.open(filename, "w") do |file|
      file.puts   "---"
      file.puts %q[title: "Home"]
      file.puts   "---"
      file.puts "total: #{posts.length}"
      file.puts
      posts.sort_by { |post| -post.created_at.to_i }.group_by{|post| post.created_at.year}.each do |year, arr|
        file.puts
        file.puts %Q[**#{year}(#{arr.length})**]
        file.puts
        arr.each do |post|
          file.puts %Q[* *#{post.created_at.strftime("%m-%d")}* #{post.to_link}]
        end
      end
    end
  end

  def create_category_file(posts)
    filename = File.join(Params::POSTS_HOME, "category.Rmd")
    File.open(filename, "w") do |file|
      file.puts   "---"
      file.puts %q[title: "Category"]
      file.puts   "---"
      
      posts.group_by{|x| x.category}.each do |cat, arr|
        file.puts
        file.puts %Q[**#{cat}(#{arr.length})**]
        file.puts
        arr.each do |post|
          file.puts %Q[* #{post.to_link}]
        end
      end
    end
  end

  def create_tag_file(posts)
    filename = File.join(Params::POSTS_HOME, "tag.Rmd")
    File.open(filename, "w") do |file|
      file.puts   "---"
      file.puts %q[title: "Tag"]
      file.puts   "---"
      posts_hash = {}
      posts.each do |post|
        post.tags.each do |tag|
          unless posts_hash[tag]
            posts_hash[tag] = [post]
          else
            posts_hash[tag] << post
          end
        end
      end

      posts_hash.each do |tag, arr|
        file.puts
        file.puts %Q[**#{tag}(#{arr.length})**]
        file.puts
        arr.each do |post|
          file.puts %Q[* #{post.to_link}]
        end
      end
    end
  end

  def copy_htmls(posts)
    # posts.each do |post|
    #   dir = File.dirname(post.dest_path)
    #   FileUtils.mkdir_p(dir, verbose: true) unless Dir.exists?(dir)
    #   FileUtils.mv(File.join(Params::POSTS_DEST, File.basename(post.dest_path)), dir)
    # end
    
  end

  def run()
    posts = get_posts(Params::POSTS_HOME)
    create_index_file(posts)
    create_category_file(posts)
    create_tag_file(posts)

    system(%Q[R -e 'Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc");rmarkdown::render_site("#{Params::POSTS_HOME}")'])
    copy_htmls(posts)
  end
end

include Generator
run()







