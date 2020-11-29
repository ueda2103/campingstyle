require "rails_helper"

RSpec.describe "PostController", type: :request do
  let(:user) { create(:user) }
  let(:post_create) { create(:post) }
  let(:post_params) { attributes_for(:post) }
  let(:invalid_post_params) { attributes_for(:post,
    post_images: "") }

  before do
    sign_in user
  end

  describe "Post新規投稿" do
    context "パラメーターが妥当な場合" do
      it "登録成功" do
        post posts_path, params: { post: post_params }
        expect(response.status).to eq 302
      end
      
      it "create成功" do
        expect do
          post posts_path, params: { post: post_params }
        end.to change(Post, :count).by 1
      end
      
      it "リダイレクト成功" do
        post posts_path, params: { post: post_params }
        expect(response).to redirect_to post_path(1)
      end
    end

    context "パラメーターが不正な場合" do
      it "登録失敗" do
        post posts_path, params: { post: invalid_post_params }
        expect(response.status).to eq 200
      end
      
      it "create失敗" do
        expect do
          post posts_path, params: { post: invalid_post_params }
        end.to_not change(Post, :count)
      end
      
      it "リダイレクト失敗" do
        post posts_path, params: { post: invalid_post_params }
        expect(response).to_not redirect_to post_path(1)
      end
    end
  end

  describe "Post編集" do
    before do
      @post = post_create
    end

    context "パラメータが正確な場合" do
      it "編集成功" do
        patch post_path(@post.id), params: { post: { title: "キャンプ２" } }
        expect(response.status).to eq 302
      end

      it "update成功" do
        patch post_path(@post.id), params: { post: { title: "キャンプ３" } }
        expect(@post.reload.title).to eq "キャンプ３"
      end

      it "リダイレクト成功" do
        patch post_path(@post.id), params: { post: { title: "キャンプ４" } }
        expect(response).to redirect_to post_path(@post.id)
      end
    end

    context "パラメータが不正な場合" do
      it "編集失敗" do
        patch post_path(@post.id), params: { post: { title: "" } }
        expect(response.status).to eq 200
      end

      it "update失敗" do
        patch post_path(@post.id), params: { post: { title: "" } }
        expect(@post.reload.title).to eq "キャンプ"
      end

      it "リダイレクト失敗" do
        patch post_path(@post.id), params: { post: { title: "" } }
        expect(response).to_not redirect_to post_path(@post.id)
      end
    end
  end

  context "Post削除" do
    before do
      @post = post_create
    end

    it "削除成功" do
      delete post_path(@post.id)
      expect(response.status).to eq 302
    end
    
    it "destroy成功" do
      expect do
        delete post_path(@post.id)
      end.to change(Post, :count).by -1
    end

    it "リダイレクト成功" do
      delete post_path(@post.id)
      expect(response).to redirect_to posts_path
    end
  end
end