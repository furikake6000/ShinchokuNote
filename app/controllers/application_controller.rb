class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UsersHelper
  include TwitterHelper
  include NotesHelper
end

#             ξ
#      　　   ll
#      　.＿＿ll＿＿
#      .／ .∽ ..　＼
#      │*　おでば　*│
#      │*　守なぐ　*│
#      │*　りいが　*│
#      │*　　　　　*│ 2018.1.1
#      .￣￣￣￣￣￣
