# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  text         :string
#  type         :string
#  order        :float
#  note_id      :bigint(8)
#  deleted_at   :datetime
#  twitter_id   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  scheduled_at :datetime
#  status       :integer
#  finished_at  :datetime
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'valid post' do
    post = create(:post)
    assert post.valid?
  end

  test 'invalid post no_type' do
    # Type "" means plain post, but it isn't allowed.
    post = create(:post)
    post.type = ''
    assert_not post.valid?
  end

  test 'invalid post wrong_type' do
    # Setting wrong type raises ArgumentError.
    post = create(:post)
    assert_raises(ArgumentError) do
      post.type = 'Undefined'
    end
  end
end
