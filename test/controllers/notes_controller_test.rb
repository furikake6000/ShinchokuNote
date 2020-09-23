require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = create(:user)
    @noritama = create(:user)
    @noriwasa = create(:user)
    @okaka_project1 = create(:project, user: @okaka)
    @noritama_project1 = create(:project, user: @noritama)

    # Noritama follows okaka
    Twitter::REST::Client.any_instance.stubs(:friendship?).with(@noritama.screen_name, @okaka.screen_name).returns(true)
    # Noriwasa doesn't follow okaka
    Twitter::REST::Client.any_instance.stubs(:friendship?).with(@noriwasa.screen_name, @okaka.screen_name).returns(false)
  end

  test 'show note for everyone' do
    # view stance: everyone
    @okaka_project1.everyone_view_stance!
    @okaka_project1.save!

    # not logged in
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show

    # unfollowed
    login_for_test @noriwasa
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @noriwasa

    # followed
    login_for_test @noritama
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @noritama

    # author
    login_for_test @okaka
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @okaka
  end

  test 'show note for only_signed' do
    # view stance: only_signed
    @okaka_project1.only_signed_view_stance!
    @okaka_project1.save!

    assert_nil current_user

    # not logged in
    get note_path(@okaka_project1)
    assert_response 403

    # unfollowed
    login_for_test @noriwasa
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @noriwasa

    # followed
    login_for_test @noritama
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @noritama

    # author
    login_for_test @okaka
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @okaka

    assert_nil current_user
  end
  
  test 'show note for only_follower' do
    # view stance: only_follower
    @okaka_project1.only_follower_view_stance!
    @okaka_project1.save!

    assert_nil current_user

    # not logged in
    get note_path(@okaka_project1)
    assert_response 403

    # unfollowed
    login_for_test @noriwasa
    get note_path(@okaka_project1)
    assert_response 403
    logout_user @noriwasa

    # followed
    login_for_test @noritama
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @noritama

    # author
    login_for_test @okaka
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @okaka

    assert_nil current_user
  end

  test 'show note for only_me' do
    # view stance: only_me
    @okaka_project1.only_me_view_stance!
    @okaka_project1.save!

    # not logged in
    get note_path(@okaka_project1)
    assert_response 403

    # unfollowed
    login_for_test @noriwasa
    get note_path(@okaka_project1)
    assert_response 403
    logout_user @noriwasa

    # followed
    login_for_test @noritama
    get note_path(@okaka_project1)
    assert_response 403
    logout_user @noritama

    # author
    login_for_test @okaka
    get note_path(@okaka_project1)
    assert_response :success
    assert_template :show
    logout_user @okaka
  end

  test 'access note watchers' do
    get note_watchers_path(@okaka_project1)
    assert_response :success
    assert_template :watchers

    login_for_test @noritama
    get note_watchers_path(@okaka_project1)
    assert_response :success
    assert_template :watchers

    login_for_test @okaka
    get note_watchers_path(@okaka_project1)
    assert_response :success
    assert_template :watchers
  end

  test 'access note edit' do
    get edit_note_path(@okaka_project1)
    assert_response 403

    login_for_test @noritama
    get edit_note_path(@okaka_project1)
    assert_response 403

    login_for_test @okaka
    get edit_note_path(@okaka_project1)
    assert_response :success
    assert_template :edit
  end

  test 'access note new' do
    get new_user_note_path(@okaka.screen_name)
    assert_response 403

    login_for_test @noritama
    get new_user_note_path(@okaka.screen_name)
    assert_response 403

    login_for_test @okaka
    get new_user_note_path(@okaka.screen_name)
    assert_response :success
    assert_template :new
  end

  test 'make new note' do
    # logging in
    login_for_test @okaka

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
    login_for_test @okaka

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
    login_for_test @okaka

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
    login_for_test @okaka

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
    login_for_test @okaka

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
    login_for_test @noritama

    # deleting a note of others
    assert_no_difference 'Note.count' do
      delete note_path(@okaka_project1)
    end

    # Check okaka_proj1 has not deleted
    assert Note.find(@okaka_project1.id)
  end

  test 'delete note of others as admin' do
    # logging in as admin
    admin = create(:user, :admin)
    login_for_test admin

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
