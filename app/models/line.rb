class Line < ActiveRecord::Base
  def self.return_ramdom_message
    messages = ["お腹すいたね〜", "位置情報ちょうだい！", "今日はこの近くでご飯にしない？", "ごはん！ごはん！"]
    messages.sample
  end
end
