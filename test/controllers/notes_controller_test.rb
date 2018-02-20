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

  test 'make new note of others' do
    # creating a note of others before logging in
    assert_no_difference 'Note.count' do
      post user_notes_path(@noritama.screen_name), params: { note: {
        type: 'Project',
        name: 'TestNote1',
        desc: 'This is description of note.'
      } }
    end

    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # creating a note of others
    assert_no_difference 'Note.count' do
      post user_notes_path(@noritama.screen_name), params: { note: {
        type: 'Project',
        name: 'TestNote2',
        desc: 'This is description of note.'
      } }
    end
  end
end
