require "rails_helper"

RSpec.describe "RecipeController", type: :request do
  let(:user) { create(:user) }
  let(:recipe_create) { create(:recipe) }
  let(:recipe_params) { attributes_for(:recipe) }
  let(:invalid_recipe_params) { attributes_for(:recipe,
    recipe_images: "") }

  before do
    sign_in user
  end

  describe "Recipe新規投稿" do
    context "パラメーターが妥当な場合" do
      it "登録成功" do
        post recipes_path, params: { recipe: recipe_params }
        expect(response.status).to eq 302
      end
      
      it "create成功" do
        expect do
          post recipes_path, params: { recipe: recipe_params }
        end.to change(Recipe, :count).by 1
      end
      
      it "リダイレクト成功" do
        post recipes_path, params: { recipe: recipe_params }
        expect(response).to redirect_to edit_recipe_path(1)
      end
    end

    context "パラメーターが不正な場合" do
      it "登録失敗" do
        post recipes_path, params: { recipe: invalid_recipe_params }
        expect(response.status).to eq 200
      end
      
      it "create失敗" do
        expect do
          post recipes_path, params: { recipe: invalid_recipe_params }
        end.to_not change(Recipe, :count)
      end
      
      it "リダイレクト失敗" do
        post recipes_path, params: { recipe: invalid_recipe_params }
        expect(response).to_not redirect_to recipe_path(1)
      end
    end
  end

  describe "Recipe編集" do
    before do
      @recipe = recipe_create
    end

    context "パラメータが正確な場合" do
      it "編集成功" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "ご飯１" } }
        expect(response.status).to eq 302
      end

      it "update成功" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "ご飯３" } }
        expect(@recipe.reload.title).to eq "ご飯３"
      end

      it "リダイレクト成功" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "ご飯４" } }
        expect(response).to redirect_to recipe_path(@recipe.id)
      end
    end

    context "パラメータが不正な場合" do
      it "編集失敗" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "" } }
        expect(response.status).to eq 200
      end

      it "update失敗" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "" } }
        expect(@recipe.reload.title).to eq "ご飯"
      end

      it "リダイレクト失敗" do
        patch recipe_path(@recipe.id), params: { recipe: { title: "" } }
        expect(response).to_not redirect_to recipe_path(@recipe.id)
      end
    end
  end

  context "Recipe削除" do
    before do
      @recipe = recipe_create
    end

    it "削除成功" do
      delete recipe_path(@recipe.id)
      expect(response.status).to eq 302
    end
    
    it "destroy成功" do
      expect do
        delete recipe_path(@recipe.id)
      end.to change(Recipe, :count).by -1
    end

    it "リダイレクト成功" do
      delete recipe_path(@recipe.id)
      expect(response).to redirect_to recipes_path
    end
  end
end