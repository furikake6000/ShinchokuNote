require 'test_helper'

module Api
  module V1
    class NotesControllerTest < ActionDispatch::IntegrationTest
      include Committee::Rails::Test::Methods

      def setup
        @project = create(:project)
      end

      def committee_options
        @committee_options ||= { schema_path: Rails.root.join('reference', 'api.v1.yaml').to_s, prefix: '/api/v1' }
      end

      test '正常なリクエスト' do
        get api_v1_note_path(@project)
        assert_response 200
        assert_schema_conform
      end
    end
  end
end
