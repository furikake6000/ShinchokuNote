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
        assert_equal post_hash['type'], post.type.downcase
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

      test 'GET /notes/{id}/posts PlainPostが日付降順にソートされる' do
        new_post = create(:post, note: @project, created_at: Time.current.next_month)
        newer_post = create(:post, note: @project, created_at: Time.current.next_month.tomorrow)

        get api_v1_note_posts_path(@project)
        r = JSON.parse(response.body)
        assert_equal r['posts'].first['id'], newer_post.id
        assert_equal r['posts'].second['id'], new_post.id
      end

      test 'GET /notes/{id}/posts Scheduleが予定日降順にソートされる' do
        new_schedule = create(
          :schedule, note: @project,
          scheduled_at: Time.current.next_month
        )
        newer_schedule = create(
          :schedule, note: @project,
          scheduled_at: Time.current.next_month.tomorrow
        )

        get api_v1_note_posts_path(@project)
        r = JSON.parse(response.body)
        assert_equal r['posts'].first['id'], newer_schedule.id
        assert_equal r['posts'].second['id'], new_schedule.id
      end

      test 'GET /notes/{id}/posts 完了済みのScheduleも予定日降順にソートされる' do
        new_schedule = create(
          :schedule, :finished, note: @project,
          finished_at: Time.current.yesterday.yesterday,
          scheduled_at: Time.current.next_month
        )
        newer_schedule = create(
          :schedule, :finished, note: @project,
          finished_at: Time.current.yesterday,
          scheduled_at: Time.current.next_month.tomorrow
        )

        get api_v1_note_posts_path(@project)
        r = JSON.parse(response.body)
        assert_equal r['posts'].first['id'], newer_schedule.id
        assert_equal r['posts'].second['id'], new_schedule.id
      end

      test 'GET /notes/{id}/posts commentに対するresponsePostを正常に出力できる' do
        post = create(:post, :with_responded_comment, note: @project)
        comment = post.responded_comment

        get api_v1_note_posts_path(@project)
        assert_response 200
        assert_response_schema_confirm
        
        r = JSON.parse(response.body)
        post_hash = r['posts'].find { |p| p['id'] == post.id }
        assert_equal post_hash['responded_comment']['text'], comment.text
        assert_equal DateTime.parse(post_hash['responded_comment']['date']).to_i, comment.created_at.to_i
      end

      test 'GET /notes/{id}/posts ページネーションで2ページ目を取ってくると先頭が31個目' do
        create_list(:post, 100, note: @project)

        get api_v1_note_posts_path(@project, page: 2)
        r = JSON.parse(response.body)
        post_hash = r['posts'].first
        assert_equal post_hash['id'], @project.posts.order('created_at DESC')[30].id
      end

      test 'GET /notes/{id}/posts メタ情報が正しい' do
        @project.posts.destroy_all
        create_list(:post, 100, note: @project)

        get api_v1_note_posts_path(@project, page: 2)
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
