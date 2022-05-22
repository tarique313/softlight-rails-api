class Api::V1::InvestmentsController < ApplicationController
  before_action :set_campaign

  def create
      investment = @campaign.investments.new(investment_params)
      if investment.save
        render json: investment
      else
        api_error(:unprocessable_entity, "Unprocessable entity", investment.errors)
      end
  end

  def show

  end

  def update

  end

  private
  def investment_params
    params.require(:investment).permit(:amount)
  end

  def set_campaign
    campaign = Campaign.find_by(id: params[:campaign_id])
    if campaign
      @campaign = campaign
    else
      api_error(:not_found, "Could not find any campaign with #{params[:campaign_id]}", nil)
    end
  end
end
