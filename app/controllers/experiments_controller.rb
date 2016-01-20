require 'infra/sfdc_manager'

class ExperimentsController < ApplicationController
	def index
		@experiments = Experiment.all
	end

	def new
		gon.campaigns = CampaignsList.flow()
	end

	def current
		@experiments = Experiment.where(:status.ne => "Complete")
	end

	def past
		@experiments = Experiment.where(:status => "Complete")
	end

	def create
		Rails.logger.info "Params are #{experiment_par}"
		@experiment = Experiment.create!(experiment_par)
		if @experiment
			render :json => @experiment.id
		end
	end

	def query_campaign
		campaign_results = CampaignQueries.flow(campaign_par)
		Rails.logger.info campaign_results
		render :json => campaign_results
	end

	def update
		Rails.logger.info "Params are #{experiment_par}"
		@experiment = Experiment.find(params[:id])
		@experiment.update(experiment_par)
		render :json => @experiment.id
	end

	def show
		gon.campaigns = CampaignsList.flow()
		@experiment = Experiment.find(params[:id])
		gon.user_id = @experiment.id
	end

	private

	def campaign_par
		params.require("query_text").permit("sfdc_control","sfdc_test","sfdc_measure")
	end

	def experiment_par
		params.require("experiments").permit("experiment_name","logged_date","logged_by","team","description","hypothesis","alpha","beta","outcome","success_a","success_b","total_a","total_b","sfdc_campaign_a","sfdc_campaign_b","metric","point_person","cost","roi","expected_val","outcome","status")
	end
end