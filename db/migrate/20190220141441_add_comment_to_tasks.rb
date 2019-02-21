class AddCommentToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :rejection_comment, :text
    add_column :tasks, :dispute_comment, :text
  end
end
