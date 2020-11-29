class ApplicationController < ActionController::Base
  private

  def check_guest
    email = current_user.email.downcase
    if email == "guest@example.com"
      redirect_to root_path, error: "ゲストユーザーの変更・削除はできません"
    end
  end
end
