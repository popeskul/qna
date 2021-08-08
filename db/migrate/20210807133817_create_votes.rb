class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true
      t.integer :value, default: 0

      t.timestamps
    end

    add_index :votes, %i[votable_id votable_type]
    add_index :votes, %i[user_id votable_id], unique: true
  end
end
