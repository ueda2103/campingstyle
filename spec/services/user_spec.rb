require "rails_helper"

RSpec.describe "UserDeviseController", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, family_name: "") }
  let(:withdrawn_user_params) { attributes_for(:user, is_deleted: "退会済") }

  describe "ユーザー新規登録" do
    context "パラメータが妥当な場合" do
      it "登録成功" do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it "create成功" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it "リダイレクト成功" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_path
      end
    end
    
    context "パラメータが不正な場合" do
      it "登録失敗" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end
      
      it "create失敗" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.to_not change(User, :count)
      end
      
      it "リダイレクト失敗" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response).to_not redirect_to root_path
      end
    end
  end

  describe "ユーザー認証" do
    context "パラメーターが正確な場合" do
      it "ログイン成功" do
        post user_session_path,
          params: {
            user: {
              email: user.email,
              password: user.password
            }
          }
        expect(response.status).to eq 302
      end

      it "リダイレクト成功" do
        post user_session_path,
          params: {
            user: {
              email: user.email,
              password: user.password
            }
          }
        expect(response).to redirect_to root_path
      end

      it "ログアウト成功" do
        delete destroy_user_session_path
        expect(response.status).to eq 302
      end

      it "リダイレクト成功" do
        delete destroy_user_session_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "パラメーターが不正な場合" do
      it "ログイン失敗" do
        post user_session_path,
          params: {
            user: {
              email: user.email,
              password: ""
            }
          }
        expect(response.status).to eq 200
      end

      it "リダイレクト失敗" do
        post user_session_path,
          params: {
            user: {
              email: user.email,
              password: ""
            }
          }
        expect(response).to_not redirect_to root_path
      end
    end

    context "退会フラグが立っている場合" do
      it "ログイン失敗" do
        post user_session_path, params: { user: withdrawn_user_params }
        expect(response).to_not redirect_to root_path
      end
    end
  end

  describe "ユーザー情報編集" do
    before do
      @user = user
      sign_in @user
    end

    it "パラメーターが妥当な場合" do
      patch user_path(@user.id), params: { user:{ email: "test_edit@gmail.com" } }
      expect(response.status).to eq 302
    end

    it "パラメータが不正な場合" do
      patch user_path(@user.id), params: { user:{ email: "" } }
      expect(response.body).to include "保存に失敗しました"
    end

    it "退会処理" do
      patch users_unsubscribe_path(@user.id), params: { user: { is_deleted: "退会済" } }
      expect(response.status).to eq 302
    end
  end
end