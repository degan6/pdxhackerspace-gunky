class CreateLogEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :log_entries do |t|
      t.string :category, null: false
      t.string :action, null: false
      t.text :message, null: false
      t.jsonb :metadata, null: false, default: {}
      t.string :ip_address
      t.text :user_agent
      t.boolean :succeeded, null: false, default: true

      t.timestamps
    end

    add_index :log_entries, [ :category, :created_at ]
    add_index :log_entries, :created_at
  end
end
