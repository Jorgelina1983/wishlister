module ApplicationHelper
  def logged_in?
    !session[:access_token].blank?
  end
end
