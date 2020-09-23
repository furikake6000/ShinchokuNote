require 'test_helper'

module Api
  module V1
    class CommentsControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      def setup
        @project = create(:project)
        @user = @project.user
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

        login_for_test @user

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

      test 'GET /notes/{id}/comments 未返信/返信済のfilterが正しく取れる' do
        @project.comments.destroy_all
        create_list(:comment, 10, to_note: @project)
        create_list(:comment, 10, :with_response, to_note: @project)

        # 未返信
        get api_v1_note_comments_path(@project, filter: 'unreplied')
        r = JSON.parse(response.body)

        # 抜き出されたコメントが全て返信済のものである
        comment_hash = r['comments']
        comment_hash.each do |c|
          assert_nil c['response_post']
        end

        # countが未返信コメントの件数のみを返す
        # total_countが全件数を返す
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 20

        # 返信済
        get api_v1_note_comments_path(@project, filter: 'replied')
        r = JSON.parse(response.body)

        # 抜き出されたコメントが全て返信済のものである
        comment_hash = r['comments']
        comment_hash.each do |c|
          assert_not_nil c['response_post']
        end

        # countが返信済コメントの件数のみを返す
        # total_countが全件数を返す
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 20
      end

      test 'GET /notes/{id}/comments お気に入りのfilterが正しく取れる' do
        @project.comments.destroy_all
        create_list(:comment, 10, to_note: @project)
        create_list(:comment, 10, :favored, to_note: @project)

        get api_v1_note_comments_path(@project, filter: 'favored')
        r = JSON.parse(response.body)

        # 抜き出されたコメントが全てfavoredされたものである
        comment_hash = r['comments']
        comment_hash.each do |c|
          assert c['favored']
        end

        # countがfavoredなコメントの件数のみを返す
        # total_countが全件数を返す
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 20
      end

      test 'GET /notes/{id}/comments ミュートされたコメントの存在がなかったことになる' do
        @project.comments.destroy_all
        create_list(:comment, 10, to_note: @project)
        create_list(:comment, 10, :muted, to_note: @project)

        get api_v1_note_comments_path(@project)
        r = JSON.parse(response.body)

        # 抜き出されたコメントが全てmutedでないものである
        comment_hash = r['comments']
        comment_hash.each do |c|
          assert_not c['muted']
        end

        # countがmutedされていないコメントの件数を返す
        # total_countがmutedされていない件数を返す
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 10
      end

      test 'GET /notes/{id}/comments block済みのユーザーからのコメントの存在がなかったことになる' do
        @project.comments.destroy_all
        blocked_user = create(:user)
        blocked_comment = create(:comment, to_note: @project, from_user: blocked_user)
        @user.user_blocks.create!(blocking_user: blocked_user, blocking_comment: blocked_comment)

        create_list(:comment, 10, to_note: @project)
        create_list(:comment, 10, to_note: @project, from_user: blocked_user)
        
        get api_v1_note_comments_path(@project)
        r = JSON.parse(response.body)

        # 抜き出されたコメントにblocked_userからのものが含まれていない
        comment_hash = r['comments']
        comment_hash.each do |c|
          next unless c.has_key?('author')
          assert_not_equal c['author']['screen_name'], blocked_user.screen_name
        end

        # countがblockされたコメントを除いてカウントする
        # total_countがblockされたコメントを除いてカウントする
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 10
      end

      test 'GET /notes/{id}/comments block済みのアドレスからのコメントの存在がなかったことになる' do
        @project.comments.destroy_all
        blocked_addr = Faker::Internet.ip_v4_address
        blocked_comment = create(:comment, to_note: @project, from_addr: blocked_addr)
        @user.user_blocks.create!(blocking_addr: blocked_addr, blocking_comment: blocked_comment)

        create_list(:comment, 10, to_note: @project)
        blocked_posts = create_list(:comment, 10, to_note: @project, from_addr: blocked_addr)
        blocked_posts_ids = blocked_posts.map(&:id)
        
        get api_v1_note_comments_path(@project)
        r = JSON.parse(response.body)

        # 抜き出されたコメントにblocked_addrからのものが含まれていない
        comment_hash = r['comments']
        comment_hash.each do |c|
          assert_not_includes blocked_posts_ids, c['id']
        end

        # countがblockされたコメントを除いてカウントする
        # total_countがblockされたコメントを除いてカウントする
        meta_hash = r['meta']
        assert_equal meta_hash['count'], 10
        assert_equal meta_hash['total_count'], 10
      end
    end
  end
end
