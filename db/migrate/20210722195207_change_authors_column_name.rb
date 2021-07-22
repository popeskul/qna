class ChangeAuthorsColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :questions, :user_id, :author_id
    rename_column :answers, :user_id, :author_id
  end
end
