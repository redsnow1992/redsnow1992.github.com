require_relative "./params.rb"
require_relative "./post.rb"

module Common
  include PostBuilder

  def get_posts(post_dir, exts = Params::EXTS, exclude_files = Params::EXCLUDE_FILES)
    posts = []
    Dir.glob(File.join(post_dir, "*")).each do |filename|
      File.open(filename, "r") do |file|
        if exts.include?(File.extname(file)[1..-1]) && !exclude_files.include?(File.basename(file))
          post = build_from_file(file)
          if post
            post.dest_path = File.join(Params::POSTS_DEST, post.html_path)
            posts << post
          end
        end
      end
    end
    posts
  end
end

# include Common
# get_posts("/Users/donald/git_repo/redsnow1992.github.io/_posts")