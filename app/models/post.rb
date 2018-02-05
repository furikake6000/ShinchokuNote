# Post class expresses posts, for example linked tweets.
class Post < ApplicationRecord
  belongs_to :note
end

class TweetPost < Post
end
