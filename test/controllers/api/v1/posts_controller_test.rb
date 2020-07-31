require 'test_helper'

module Api
  module V1
    class PostsControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      def setup
        @project = create(:project)
      end

      # GET /notes/{id}/posts

      test 'GET /notes/{id}/posts 正常なリクエスト' do
        get api_v1_note_posts_path(@project)
        assert_response 200
        assert_response_schema_confirm
        
        r = JSON.parse(response.body)
        assert r.has_key?('posts')
        
        post_hash = r['posts'].first
        post = Post.find(post_hash['id'])
        assert_equal post_hash['type'], post.type
        assert_equal post_hash['text'], post.text
        assert_equal DateTime.parse(post_hash['date']).to_i, post.created_at.to_i
      end

      test 'GET /notes/{id}/posts 存在しないnoteへのリクエスト' do
        @project.destroy!

        get api_v1_note_posts_path(@project)
        assert_response 404
      end

      test 'GET /notes/{id}/posts アクセス不可なnoteへのリクエスト' do
        @project.only_me_view_stance!

        # 未ログイン時403
        get api_v1_note_posts_path(@project)
        assert_response 403

        login_for_test @project.user

        # 作成者ログイン時200
        get api_v1_note_posts_path(@project)
        assert_response 200
      end
    end
  end
end
