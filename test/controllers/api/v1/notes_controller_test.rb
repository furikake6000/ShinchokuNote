require 'test_helper'

module Api
  module V1
    class NotesControllerTest < ActionDispatch::IntegrationTest
      include UsersHelper

      let(:project) { create :project }
      let(:addr) { '198.51.100.1' }

      describe 'GET /notes/{id}' do
        subject do
          get api_v1_note_path(project),
              headers: { 'REMOTE_ADDR' => addr } 
        end

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

        describe 'is_watchingに関して' do
          it '未ログイン時 falseが返る' do
            subject
            refute JSON.parse(response.body)['is_watching']
          end

          describe 'ログイン時' do
            let(:watcher) { create :user }
            before { login_for_test watcher }

            it 'ウォッチしていない場合 falseが返る' do
              subject
              refute JSON.parse(response.body)['is_watching']
            end

            describe 'ウォッチしている場合' do
              before { Watchlist.create!(watching_user: watcher, watching_note: project) }

              it 'trueが返る' do
                subject
                assert JSON.parse(response.body)['is_watching']
              end
            end
          end
        end

        describe 'sent_shinchoku_dodeskaに関して' do
          describe '未ログイン時' do
            it '進捗どうですかを送っていない場合 falseが返る' do
              subject
              refute JSON.parse(response.body)['sent_shinchoku_dodeska']
            end

            describe '進捗どうですかを送った場合' do
              before { create :shinchoku_dodeska, from_addr: addr, to_note: project }

              it 'trueが返る' do
                subject
                assert JSON.parse(response.body)['sent_shinchoku_dodeska']
              end
            end
          end

          describe 'ログイン時' do
            let(:watcher) { create :user }
            before { login_for_test watcher }

            it '進捗どうですかを送っていない場合 falseが返る' do
              subject
              refute JSON.parse(response.body)['sent_shinchoku_dodeska']
            end

            describe '進捗どうですかを送った場合' do
              before { create :shinchoku_dodeska, from_user: watcher, to_note: project }

              it 'trueが返る' do
                subject
                assert JSON.parse(response.body)['sent_shinchoku_dodeska']
              end
            end
          end
        end
      end
    end
  end
end
