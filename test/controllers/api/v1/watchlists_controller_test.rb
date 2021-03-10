require 'test_helper'

module Api
  module V1
    class WatchlistsControllerTest < ActionDispatch::IntegrationTest
      describe 'Api::V1::WatchlistsController' do
        include UsersHelper

        let(:project) { create :project }
        let(:user) { project.user }
        let(:watcher) { create :user }

        before do
          login_for_test user
        end

        describe 'POST /notes/{id}/watchlist' do
          subject { post api_v1_note_watchlist_path(project) }

          it '201を返す' do
            subject
            assert_response :created
            assert_request_schema_confirm
          end
        end

        describe 'DELETE /notes/{id}/watchlist' do
          subject { delete api_v1_note_watchlist_path(project) }

          it '201を返す' do
            subject
            assert_response :created
            assert_request_schema_confirm
          end
        end
      end
    end
  end
end
