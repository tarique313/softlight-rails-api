class CreateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :investments do |t|
      t.decimal :amount
      t.references :campaign, index: true, foreign_key: true

      t.timestamps
    end
  end
end
