require 'rails_helper'
include ApplicationHelper

RSpec.describe ApplicationHelper do
  describe "#return_unknown_if_blank" do
    context "when the argument is blank" do
      it "returns unknown" do
        expect(return_unknown_if_blank("")).to eq("不明")
      end
    end

    context "when the argument is not blank" do
      it "returns the argument" do
        expect(return_unknown_if_blank("test")).to eq("test")
      end
    end
  end
end
