class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :jp_name
      t.string :company_name
      t.string :payment_type
      t.string :description

      t.timestamps
    end
  end
end
