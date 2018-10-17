# Ref: https://doruby.jp/users/ueki/entries/Rails%E3%81%A7Logger%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6Log%E3%83%AD%E3%83%BC%E3%83%86%E3%82%B7%E3%83%A7%E3%83%B3

module Tasks
  module LogDeleter
    require 'fileutils'
    require 'active_support'
    class << self
      def delete_logs_of_last_week
        time = Time.current.days_ago(7).strftime('%Y%m%d%H%M%S')
        
        # dailyの日付付きログファイルを全て取得
        log_all = Dir.glob("#{Rails.root}/log/daily.log.*")
        log_all.each do |i|
          if File.stat(i).mtime.strftime('%Y%m%d%H%M%S') < time
            FileUtils.rm_f(i)
          end
        end
      end
    end
  end
end