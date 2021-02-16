class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params) # インスタンス変数を定義してif文で条件分岐する
    if @prototype.save # 保存された場合トップページへ
      redirect_to root_path
    else
      render :new # 保存されなければ投稿ページに留まる
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user.id == current_user.id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      redirect_to root_path
    end
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
