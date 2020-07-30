require 'test_helper'

module Api
  module V1
    class NotesControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      def setup
        @project = create(:project)
      end

      # GET /notes/{id}

      test 'GET /notes/{id} 正常なリクエスト' do
        get api_v1_note_path(@project)
        assert_response 200
        assert_response_schema_confirm
        
        r = JSON.parse(response.body)
        assert_equal r['type'], 'Project'
        assert_equal r['name'], @project.name
        assert_equal r['desc'], @project.desc
        assert_equal r['stage'], @project.stage
        assert_equal r['view_stance'], @project.view_stance
        assert_equal r['rating'], @project.rating
        assert_equal r['url'], note_path(@project)
        assert_equal r['watch_url'], note_watchlists_toggle_path(@project)
        assert_equal r['watchers_count'], @project.watching_users.count
        assert_equal r['shinchoku_dodeskas_count'], @project.shinchoku_dodeskas.count
        assert_equal r['comments_count'], @project.comments.count
        assert_equal DateTime.parse(r['created_at']).to_i, @project.created_at.to_i
      end

      test 'GET /notes/{id} 存在しないnoteへのリクエスト' do
        @project.destroy!

        get api_v1_note_path(@project)
        assert_response 404
      end

      test 'GET /notes/{id} アクセス不可なnoteへのリクエスト' do
        @project.only_me_view_stance!

        # 未ログイン時403
        get api_v1_note_path(@project)
        assert_response 403

        login_for_test @project.user

        # 作成者ログイン時200
        get api_v1_note_path(@project)
        assert_response 200
      end
    end
  end
end
