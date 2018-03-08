require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @noritama_project1 = notes(:noritama_project_1)
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
      post user_notes_path(@okaka.screen_name), params: { note: {
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

  test 'edit note' do
    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # editing a note
    patch note_path(@okaka_project1), params: { project: {
      type: 'Project',
      name: 'renamed',
      desc: 'Edited.'
    } }

    # load edited note
    edited_note = Note.find_by(id: @okaka_project1.id)
    assert_equal edited_note.name, 'renamed'
    assert_equal edited_note.desc, 'Edited.'
  end

  test 'edit note of others' do
    # editing a note without logging in
    patch note_path(@okaka_project1), params: { project: {
      type: 'Project',
      name: 'renamed',
      desc: 'Edited.'
    } }

    # load edited note
    edited_note = Note.find_by(id: @okaka_project1.id)
    # assert not changed
    assert_equal edited_note, @okaka_project1

    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # creating a note of others
    patch note_path(@noritama_project1), params: { project: {
      type: 'Project',
      name: 'renamed',
      desc: 'Edited.'
    } }

    # load edited note
    edited_note = Note.find_by(id: @noritama_project1.id)
    # assert not changed
    assert_equal edited_note, @noritama_project1
  end

  test 'delete note' do
    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # deleting a note
    assert_difference '@okaka.notes.count', -1 do
      delete note_path(@okaka_project1)
    end
  end

  test 'delete note of others' do
    # deleting a note without logging in
    assert_no_difference 'Note.count' do
      delete note_path(@okaka_project1)
    end

    # logging in
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # deleting a note of others
    assert_no_difference 'Note.count' do
      delete note_path(@noritama_project1)
    end
  end
end
