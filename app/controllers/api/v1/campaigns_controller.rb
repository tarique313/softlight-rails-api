class Api::V1::CampaignsController < ApplicationController

  before_action :set_campaign, only: [:show, :update]

  def index
    if params[:type].present? and params[:type] == "number_of_investors"
      campaign_sql = "select c.id,c.name, COUNT(c.id) as total_investors from campaigns as c inner join investments as i on c.id = i.campaign_id group by c.id order by c.id DESC"
      campaigns = ActiveRecord::Base.connection.execute(campaign_sql)
      render json: campaigns.as_json
    elsif params[:type].present? and params[:value].present?
      campaigns = Campaign.where("#{params[:type]}": params[:value]).limit(20).order('id DESC')
      render json: campaigns.all
    else
      render json: Campaign.limit(20).order('id DESC')
    end
  end

  def create
    campaign = Campaign.new(campaign_params)
    campaign.save
    if campaign.errors.empty?
      render json: campaign
    else
      api_error(:unprocessable_entity, "Unprocessable Entity", campaign.errors)
    end
  end
  # create investment
  # update percentage raised
  def show
    render json: @campaign
  end

  def update

    if @campaign.update(update_campaign_params)
      render json: @campaign
    else
      api_error(:unprocessable_entity, "unprocessable entry", @campaign.errors)
    end
  end

  private
  def campaign_params
    params.require(:campaign).permit(:name, :image, :target_amount, :sector, :country, :investment_multiple)
  end

  def update_campaign_params
    params.require(:campaign).permit(:name, :image, :target_amount, :sector, :country)
  end

  def set_campaign
    campaign = Campaign.find_by(id: params[:campaign_id])
    if campaign
      @campaign = campaign
    else
      api_error(:not_found, "Could not find any campaign with #{params[:id]}", nil)
    end
  end
end
