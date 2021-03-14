require 'test_helper'

module Api
  module V1
    class WatchlistsControllerTest < ActionDispatch::IntegrationTest
      describe 'Api::V1::WatchlistsController' do
        include UsersHelper

        let(:project) { create :project }

        describe 'POST /notes/{id}/watchlist' do
          subject { post api_v1_note_watchlist_path(project) }

          it '201を返す' do
            subject
            assert_response :created
            assert_request_schema_confirm
          end

          describe 'ノートが存在しない場合' do
            before { project.destroy! }
            
            it '404を返す' do
              subject
              assert_response :not_found
            end
          end

          describe 'ノートを閲覧する権限がない場合' do
            before { project.only_me_view_stance! }

            it '403を返す' do
              subject
              assert_response :forbidden
            end
          end
        end

        describe 'DELETE /notes/{id}/watchlist' do
          subject { delete api_v1_note_watchlist_path(project) }

          it '201を返す' do
            subject
            assert_response :created
            assert_request_schema_confirm
          end

          describe 'ノートが存在しない場合' do
            before { project.destroy! }
            
            it '404を返す' do
              subject
              assert_response :not_found
            end
          end

          describe 'ノートを閲覧する権限がない場合' do
            before { project.only_me_view_stance! }

            it '403を返す' do
              subject
              assert_response :forbidden
            end
          end
        end
      end
    end
  end
end
