class RenameAvatar < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    add_column :users, :avatar, :string
  end
end
