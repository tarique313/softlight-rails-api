require 'rails_helper'

describe 'Campaign Api', type: :request do
  describe 'GET /campaigns' do
    it 'returns all campaigns' do
      FactoryBot.create(:campaign, name: "Test Campaign 1", image: "Test_image1.png", target_amount: 1000, sector: "IT", country: "UK", investment_multiple: 10)
      FactoryBot.create(:campaign, name: "Test Campaign 2", image: "Test_image2.png", target_amount: 2000, sector: "EDUCATION", country: "USA", investment_multiple: 20)

      get '/api/v1/campaigns'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /campaigns' do
    it 'creates a new campaign' do
      expect{
      post '/api/v1/campaigns', params: {campaign: {name: "Test Campaign 3", image: "Test_image3.png", target_amount: 1000, sector: "IT", country: "UK", investment_multiple: 30}}
      }.to change {Campaign.count}.from(0).to(1)
      expect(response).to have_http_status(:success)
    end
  end
  describe 'POST /campaigns' do
    it 'creates valid campaign attributes' do
      # send a POST request to /campaigns, with these parameters
      # The controller will treat them as JSON
      post '/api/v1/campaigns', params: {
        campaign: {
          name: "Test Campaign 3",
          image: "Test_image3.png",
          target_amount: 1000.0,
          sector: "IT",
          country: "UK",
          investment_multiple: 30.0
        }
      }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys
      # # check the value of the returned response hash
      expect(json[:name]).to eq('Test Campaign 3')
      expect(json[:image]).to eq('Test_image3.png')
      #expect(json[:target_amount]).to be_same_number_as(1000.0)
      expect(json[:sector]).to eq('IT')
      expect(json[:country]).to eq('UK')
      #expect(json[:investment_multiple]).to be_same_number_as(30.0)
      expect(Campaign.last.name).to eq('Test Campaign 3')
    end

    it 'invalid campaign attributes' do
      post '/api/v1/campaigns', params: {
        campaign: {
          name: "",
          image: "",
          target_amount: 1000.0,
          sector: "IT",
          country: "UK",
          investment_multiple: 30.0
        }
      }

      expect(response.status).to eq(422)

      # json = JSON.parse(response.body).deep_symbolize_keys
      # expect(json[:name]).to eq(["can not be blank"])

      # no new Campaign record is created
      expect(Campaign.count).to eq(0)
    end
  end

  describe "PUT /api/v1/campaigns/:id" do
    let!(:campaign) { Campaign.create(name: "Test Campaign 4",
                                      image: "Test_image4.png",
                                      target_amount: 2000.0,
                                      sector: "Education",
                                      country: "USA",
                                      investment_multiple: 20.0) }

    it 'should have valid campaign attributes' do
      # send put request to /campaign/:id
      put "/api/v1/campaigns/#{campaign.id}", params: {
        campaign: {
          name: "Updated Test Campaign",
          image: "Updated Test_image4.png",
          target_amount: 3000.0,
          sector: "Education",
          country: "BD",
          investment_multiple: 30.0
        }
      }

      # response should have HTTP Status 200 OK
      expect(response).to have_http_status(:created)

      # response should contain JSON of the updated object
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq('Updated Test Campaign')
      expect(json[:image]).to eq('Updated Test_image4.png')

      # The bookmark title and url should be updated
      expect(campaign.reload.name).to eq('Updated Test Campaign')
      expect(campaign.reload.image).to eq('Updated Test_image4.png')
    end

    it 'should invalid campaign attributes' do
      # send put request to /campaign/:id
      put "/api/v1/campaigns/#{campaign.id}", params: {
        campaign: {
          name: "",
          image: "",
          target_amount: 3000.0,
          sector: "Education",
          country: "BD",
          investment_multiple: 30.0
        }
      }

      # response should have HTTP Status 422 Unprocessable entity
      expect(response).to have_http_status(:created)

      # response should contain error message
      # json = JSON.parse(response.body).deep_symbolize_keys
      # expect(json[:url]).to eq(["can't be blank"])

      # The bookmark title and url remain unchanged
      expect(campaign.reload.title).to eq('Test Campaign 4')
      expect(campaign.reload.image).to eq('Test_image4.png')
    end
  end


end