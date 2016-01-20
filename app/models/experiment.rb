class Experiment
	include Mongoid::Document

	field :experiment_name, type: String
	field :logged_date, type: String
	field :team, type: String
	field :description, type: String
	field :hypothesis, type: String
	field :alpha, type: Integer
	field :beta, type: Integer
	field :outcome, type: String
	field :success_a, type: Integer
	field :success_b, type: Integer
	field :total_a, type: Integer
	field :total_b, type: Integer
	field :sfdc_campaign_a, type: String
	field :sfdc_campaign_b, type: String
	field :metric, type: String
	field :point_person, type: String
	field :cost, type: String
	field :roi, type: String
	field :status, type: String
	field :expected_val, type: String
end