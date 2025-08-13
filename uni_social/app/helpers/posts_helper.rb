module PostsHelper
  def post_text(post)
    post.respond_to?(:content) && post.content.present? ? post.content : post.body
  end
end
