require 'test_helper'

module Api
  module V1
    class NotesControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      let(:project) { create :project }
      let(:watcher) { create :user }

      describe 'GET /notes/{id}' do
        subject { get api_v1_note_path(project) }

        it '200が返る' do
          subject
          assert_response :ok
          assert_response_schema_confirm
        end

        it '正しい値が返る' do
          subject
          r = JSON.parse(response.body)
          assert_equal r['type'], 'project'
          assert_equal r['name'], project.name
          assert_equal r['desc'], project.desc
          assert_equal r['stage'], project.stage
          assert_equal r['view_stance'], project.view_stance
          assert_equal r['rating'], project.rating
          assert_equal r['url'], note_path(project)
          assert_equal r['watch_url'], note_watchlists_toggle_path(project)
          assert_equal r['watchers_count'], project.watching_users.count
          assert_equal r['shinchoku_dodeskas_count'], project.shinchoku_dodeskas.count
          assert_equal r['comments_count'], project.comments.count
          assert_equal DateTime.parse(r['created_at']).to_i, project.created_at.to_i
        end

        describe 'ノートが存在しない場合' do
          before { project.destroy! }

          it '404が返る' do
            subject
            assert_response :not_found
          end
        end

        describe '作成者だけ閲覧可なnoteへのリクエスト' do
          before { project.only_me_view_stance! }

          it '未ログイン時403が返る' do
            subject
            assert_response :forbidden
          end

          describe '作成者としてログインした場合' do
            before { login_for_test project.user }

            it '200が返る' do
              subject
              assert_response :ok
            end
          end
        end
      end
    end
  end
end
