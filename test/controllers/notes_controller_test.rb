require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
  end

  test 'make new note' do
    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # creating a note
    assert_difference '@okaka.notes.count', 1 do
      post user_notes_path(@okaka.screen_name), params: { note: {
        type: 'Project',
        name: 'TestNote',
        desc: 'This is description of note.'
      } }
    end
  end
end
