require 'test_helper'

module Api
  module V1
    class WatchlistsControllerTest < ActionDispatch::IntegrationTest
      describe 'Api::V1::WatchlistsController' do
        include UsersHelper

        let(:project) { create :project }
        let(:watcher) { create :user }

        before do
          login_for_test watcher
        end

        describe 'POST /notes/{id}/watchlist' do
          subject { post api_v1_note_watchlist_path(project) }

          it 'ウォッチリストが追加され201を返す' do
            assert_difference 'Watchlist.count', 1 do
              subject
            end
            assert watcher.watching_notes.include?(project)
            assert_response :created
          end

          describe '元々ウォッチしていた場合' do
            before { Watchlist.create!(watching_user: watcher, watching_note: project) }

            it '400を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :bad_request
            end
          end

          describe 'ノートが存在しない場合' do
            before { project.destroy! }
            
            it '404を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :not_found
            end
          end

          describe 'ノートを閲覧する権限がない場合' do
            before { project.only_me_view_stance! }

            it '403を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :forbidden
            end
          end
        end

        describe 'DELETE /notes/{id}/watchlist' do
          subject { delete api_v1_note_watchlist_path(project) }

          describe '元々登録していた場合' do
            before { Watchlist.create!(watching_user: watcher, watching_note: project) }

            it 'ウォッチリストが外れ200を返す' do
              assert_difference 'Watchlist.count', -1 do
                subject
              end
              refute watcher.watching_notes.include?(project)
              assert_response :ok
            end
          end

          describe '登録していなかった場合' do
            it '400を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :bad_request
            end
          end

          describe 'ノートが存在しない場合' do
            before { project.destroy! }
            
            it '404を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :not_found
            end
          end

          describe 'ノートを閲覧する権限がない場合' do
            before { project.only_me_view_stance! }

            it '403を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :forbidden
            end
          end
        end
      end
    end
  end
end
