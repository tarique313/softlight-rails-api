class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :image
      t.decimal :percentage_raised
      t.decimal :target_amount
      t.string :sector
      t.string :country
      t.decimal :investment_multiple

      t.timestamps
    end
  end
end
