module UsersHelper
  def thumb_img user, options={}
    avatar_url = user.avatar.url(:thumb)
    image_tag(avatar_url, class: options[:class])
  end
end
