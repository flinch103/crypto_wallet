class AddResolvedIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :resolved_id, :integer
  end
end
