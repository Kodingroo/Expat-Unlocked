class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :name
      t.string :title
      t.string :type
      t.string :due_date
      t.string :current_due_amount

      t.timestamps
    end
  end
end
