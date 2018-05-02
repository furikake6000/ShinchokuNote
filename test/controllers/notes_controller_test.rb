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

  test 'access note show' do
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show

    login_as_noritama
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show

    login_as_okaka
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
  end

  test 'access note edit' do
    get edit_note_path(@okaka_project1)
    assert_response 403

    login_as_noritama
    get edit_note_path(@okaka_project1)
    assert_response 403

    login_as_okaka
    get edit_note_path(@okaka_project1)
    assert_response :success
    assert_template :edit
  end

  test 'access note new' do
    get new_user_note_path(@okaka.screen_name)
    assert_response 403

    login_as_noritama
    get new_user_note_path(@okaka.screen_name)
    assert_response 403

    login_as_okaka
    get new_user_note_path(@okaka.screen_name)
    assert_response :success
    assert_template :new
  end

  test 'make new note' do
    # logging in
    login_as_okaka

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
    login_as_okaka

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
    login_as_okaka

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
    login_as_okaka

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
    login_as_okaka

    # deleting a note
    assert_difference '@okaka.notes.count', -1 do
      delete note_path(@okaka_project1)
    end

    # Check okaka_proj1 has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Note.find(@okaka_project1.id)
    end
    # check okaka has deleted logically(paranoid)
    okaka_proj1_tomb = Note.with_deleted.find(@okaka_project1.id)
    assert okaka_proj1_tomb
    assert okaka_proj1_tomb.deleted?
  end

  test 'delete note of others' do
    # deleting a note without logging in
    assert_no_difference 'Note.count' do
      delete note_path(@okaka_project1)
    end

    # logging in
    login_as_noritama

    # deleting a note of others
    assert_no_difference 'Note.count' do
      delete note_path(@okaka_project1)
    end

    # Check okaka_proj1 has not deleted
    assert Note.find(@okaka_project1.id)
  end

  test 'delete note of others as admin' do
    # logging in
    login_as_okaka

    # deleting a note of others
    assert_difference 'Note.count', -1 do
      delete note_path(@noritama_project1)
    end

    # Check noritama_proj1 has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Note.find(@noritama_project1.id)
    end
    # check noritama has deleted logically(paranoid)
    noritama_proj1_tomb = Note.with_deleted.find(@noritama_project1.id)
    assert noritama_proj1_tomb
    assert noritama_proj1_tomb.deleted?
  end
end
