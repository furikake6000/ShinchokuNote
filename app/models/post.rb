class Post < ApplicationRecord
  belongs_to :note
end

class TweetPost < Post
end
