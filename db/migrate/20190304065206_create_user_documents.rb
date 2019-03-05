class CreateUserDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_documents do |t|
      t.references :user, foreign_key: true
      t.references :document
      t.string :title

      t.string :doc_type

      t.string :photo
      t.boolean :state, default: false
      t.date :due_date
      t.integer :remaining_balance
      t.integer :current_due_amount

      t.date :reminder_date


      t.timestamps
    end
  end
end
