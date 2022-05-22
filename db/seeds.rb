# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
campaigns = []
(1..20).each do |campaign_index|
  campaigns.push({name: "Campaign_#{campaign_index}",
                  image: "campaign_#{campaign_index}_image.png",
                  target_amount: rand(100..10000),
                  investment_multiple: rand(10..100).round(2),
                  sector: "IT",
                  country: "BD"})
end

Campaign.create(campaigns)
#

