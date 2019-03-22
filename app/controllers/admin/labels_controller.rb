class Admin::LabelsController < ApplicationController
  def index
    @labels = Label.all
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to admin_labels_path, notice: "ラベル: #{@label.title}を追加しました"
    else
      # バリデーションにかかった場合はフラッシュでエラーメッセージを表示
      redirect_to admin_labels_path, flash: { error: @label.errors.full_messages[0]}
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.delete
    redirect_to admin_labels_path, notice: "ラベル: #{@label.title}を削除しました"
  end

  private
  
  def label_params
    params.require(:label).permit(:title)
  end
end