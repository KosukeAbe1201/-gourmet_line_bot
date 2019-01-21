require 'rails_helper'

RSpec.describe LineBot, type: :model do
  describe "return_ramdom_message" do
      it "return ramdom message" do
        expect(
          LineBot::return_ramdom_message
        ).to eq("お腹すいたね〜")
        .or eq("位置情報ちょうだい！")
        .or eq("今日はこの近くでご飯にしない？")
        .or eq("ごはん！ごはん！")
    end
  end
end
