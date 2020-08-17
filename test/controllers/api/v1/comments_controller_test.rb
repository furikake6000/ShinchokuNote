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

      test 'GET /notes/{id}/comments commentに対するresponsePostを正常に出力できる' do
        post = create(:post, :with_responded_comment, note: @project)
        comment = post.responded_comment

        get api_v1_note_comments_path(@project)
        assert_response 200
        assert_response_schema_confirm
        
        r = JSON.parse(response.body)
        comment_hash = r['comments'].find { |c| c['id'] == comment.id }
        assert_equal comment_hash['response_post']['text'], post.text
        assert_equal DateTime.parse(comment_hash['response_post']['date']).to_i, post.created_at.to_i
      end

      test 'GET /notes/{id}/comments ページネーションで2ページ目を取ってくると先頭が31個目' do
        create_list(:comment, 100, to_note: @project)

        get api_v1_note_comments_path(@project, page: 2)
        r = JSON.parse(response.body)
        comment_hash = r['comments'].first
        assert_equal comment_hash['id'], @project.comments[30].id
      end

      test 'GET /notes/{id}/comments メタ情報が正しい' do
        @project.comments.destroy_all
        create_list(:comment, 100, to_note: @project)

        get api_v1_note_comments_path(@project, page: 2)
        r = JSON.parse(response.body)
        meta_hash = r['meta']
        assert_equal meta_hash['current_page'], 2
        assert_equal meta_hash['total_pages'], 4
        assert_equal meta_hash['count'], 30
        assert_equal meta_hash['total_count'], 100
      end
    end
  end
end
