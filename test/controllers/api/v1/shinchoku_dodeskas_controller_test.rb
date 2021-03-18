require 'test_helper'

module Api
  module V1
    class ShinchokuDodeskasControllerTest < ActionDispatch::IntegrationTest
      describe 'Api::V1::ShinchokuDodeskasController' do
        include UsersHelper

        let(:project) { create :project }

        describe 'POST /notes/{id}/shinchoku_dodeska' do
          subject { post api_v1_note_shinchoku_dodeska_path(project) }

          it '201を返す' do
            subject
            assert_response :created
          end
        end

        describe 'DELETE /notes/{id}/shinchoku_dodeska' do
          subject { delete api_v1_note_shinchoku_dodeska_path(project) }

          it '200を返す' do
            subject
            assert_response :ok
          end
        end
      end
    end
  end
end
