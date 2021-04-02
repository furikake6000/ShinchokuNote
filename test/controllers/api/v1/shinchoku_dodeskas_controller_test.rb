require 'test_helper'

module Api
  module V1
    class ShinchokuDodeskasControllerTest < ActionDispatch::IntegrationTest
      describe 'Api::V1::ShinchokuDodeskasController' do
        include UsersHelper

        let(:project) { create :project }
        let(:watcher) { create :user }
        let(:addr) { '198.51.100.1' }

        before do
          login_for_test watcher
        end

        describe 'POST /notes/{id}/shinchoku_dodeska' do
          let(:content) { '' }

          subject do
            post api_v1_note_shinchoku_dodeska_path(project),
                 params: { content: content },
                 headers: { 'REMOTE_ADDR' => addr } 
          end

          it '進捗どうですかが追加され201を返す' do
            assert_difference 'ShinchokuDodeska.count', 1 do
              subject
            end
            assert_response :created
          end

          it '作成された進捗どうですかのfrom_userは作成者である' do
            subject

            new_dodeska = ShinchokuDodeska.last
            assert_equal new_dodeska.from_user watcher
          end

          describe '既に進捗どうですかを作成していた場合' do
            before { create :shinchoku_dodeska, from_user: watcher, to_note: project }

            it '400を返す' do
              assert_no_difference 'ShinchokuDodeska.count' do
                subject
              end
              assert_response :bad_request
            end
          end

          describe 'ログインしていない場合' do
            before { logout_for_test }

            it '進捗どうですかが作成され201を返す' do
              assert_no_difference 'Watchlist.count' do
                subject
              end
              assert_response :bad_request
            end

            it '作成された進捗どうですかのfrom_userはnilでありfrom_addrは自分のアドレスである' do
              subject

              new_dodeska = ShinchokuDodeska.last
              assert_nil new_dodeska.from_user
              assert_equal new_dodeska.from_addr, addr
            end

            describe '既に進捗どうですかを作成していた場合' do
              before { create :shinchoku_dodeska, from_user: watcher, to_note: project }

              it '400を返す' do
                assert_no_difference 'ShinchokuDodeska.count' do
                  subject
                end
                assert_response :bad_request
              end
            end
          end
          
          describe 'ノートが存在しない場合' do
            before { project.destroy! }
            
            it '404を返す' do
              assert_no_difference 'ShinchokuDodeska.count' do
                subject
              end
              assert_response :not_found
            end
          end

          describe 'ノートを閲覧する権限がない場合' do
            before { project.only_me_view_stance! }

            it '403を返す' do
              assert_no_difference 'ShinchokuDodeska.count' do
                subject
              end
              assert_response :forbidden
            end
          end
        end

        describe 'DELETE /notes/{id}/shinchoku_dodeska' do
          subject { delete api_v1_note_shinchoku_dodeska_path(project) }

          describe '既に進捗どうですかを作成していた場合' do
            before { create :shinchoku_dodeska, from_user: watcher, to_note: project }

            it '200を返す' do
              assert_difference 'ShinchokuDodeska.count', -1 do
                subject
              end
              assert_response :bad_request
            end
          end

          describe '進捗どうですかを作成していなかった場合' do
            it '400を返す' do
              assert_no_difference 'ShinchokuDodeska.count' do
                subject
              end
              assert_response :bad_request
            end
          end

          describe 'ログインしていない場合' do
            before { logout_for_test }

            describe '既に進捗どうですかを作成していた場合' do
              before { create :shinchoku_dodeska, from_addr: addr, to_note: project }

              it '200を返す' do
                assert_difference 'ShinchokuDodeska.count', -1 do
                  subject
                end
                assert_response :bad_request
              end
            end

            describe '進捗どうですかを作成していなかった場合' do
              it '400を返す' do
                assert_no_difference 'ShinchokuDodeska.count' do
                  subject
                end
                assert_response :bad_request
              end
            end
          
            describe 'ノートが存在しない場合' do
              before { project.destroy! }
              
              it '404を返す' do
                assert_no_difference 'ShinchokuDodeska.count' do
                  subject
                end
                assert_response :not_found
              end
            end
  
            describe 'ノートを閲覧する権限がない場合' do
              before { project.only_me_view_stance! }
  
              it '403を返す' do
                assert_no_difference 'ShinchokuDodeska.count' do
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
end
