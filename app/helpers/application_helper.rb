module ApplicationHelper
  def return_unknown_if_blank(param)
    param == "" ? "不明" : param
  end
end
