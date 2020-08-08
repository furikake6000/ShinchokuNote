require 'test_helper'

module Api
  module V1
    class CommentsControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      def setup
        @project = create(:project)
      end

      # GET /notes/{id}/comments

      test 'GET /notes/{id}/comments 正常なリクエスト' do
        get api_v1_note_comments_path(@project)
        assert_response 200
        assert_response_schema_confirm
        
        r = JSON.parse(response.body)
        assert r.has_key?('comments')
        
        comment_hash = r['comments'].first
        comment = Comment.find(comment_hash['id'])
        assert_equal comment_hash['text'], comment.text
        assert_equal DateTime.parse(comment_hash['date']).to_i, comment.created_at.to_i
      end

      test 'GET /notes/{id}/comments 存在しないnoteへのリクエスト' do
        @project.destroy!

        get api_v1_note_comments_path(@project)
        assert_response 404
      end

      test 'GET /notes/{id}/comments アクセス不可なnoteへのリクエスト' do
        @project.only_me_view_stance!

        # 未ログイン時403
        get api_v1_note_comments_path(@project)
        assert_response 403

        login_for_test @project.user

        # 作成者ログイン時200
        get api_v1_note_comments_path(@project)
        assert_response 200
      end

      test 'GET /notes/{id}/comments 日付降順にソートされる' do
        new_comment = create(:comment, to_note: @project)
        newer_comment = create(:comment, to_note: @project)

        get api_v1_note_comments_path(@project)
        r = JSON.parse(response.body)
        assert_equal r['comments'].first['id'], newer_comment.id
        assert_equal r['comments'].second['id'], new_comment.id
      end
    end
  end
end
