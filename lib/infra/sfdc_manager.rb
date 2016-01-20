require 'restforce'

module SfdcConnection
  def sfdc_client
    return @sfdc_client if @sfdc_client

    @sfdc_client = Restforce.new :username => 'dror@honeybook.com',
                                 :password => 'Shi029942077',
                                 :security_token => 'yxpQbvE5ESMQLToPRuoiTuLHE',
                                 :client_id => '3MVG9fMtCkV6eLhfJ2tr9prPDPEHd8tv8brqazVyqvX0Sb_aqulBUeIKaKKe21ewbBiXse39WKwahj9Gg6HKW',
                                 :client_secret => '157741180091668371'
    @sfdc_client
  end
end

class CampaignsList
	include SfdcConnection

	def self.flow
		obj = self.new
		customers = obj.sfdc_client.query("SELECT Name FROM Campaign")
	end
end

class CampaignQueries
  include SfdcConnection

  def self.flow(campaign_par)
    Rails.logger.info campaign_par
    obj = self.new
    results = {}

    measure_map = {"Qualification Rate": ['NumberOfConvertedLeads','NumberOfLeads'],
      "Win Rate": ['NumberOfWonOpportunities','NumberOfLeads'],
      "Close Rate": ['NumberOfWonOpportunities','NumberOfConvertedLeads']
    }

    metrics = measure_map[campaign_par["sfdc_measure"].to_sym]

    control_name = campaign_par["sfdc_control"]
    control = obj.sfdc_client.query("SELECT NumberOfConvertedLeads, NumberOfLeads, NumberOfWonOpportunities FROM Campaign WHERE Name='#{control_name}'").first
    return "Could not find control campaign" if !control

    results[:controlSuccesses] = control[metrics.first]
    results[:controlFailures] = control[metrics.last] - control[metrics.first]

    treatment_name = campaign_par["sfdc_test"]
    treatment = obj.sfdc_client.query("SELECT NumberOfConvertedLeads, NumberOfLeads, NumberOfWonOpportunities FROM Campaign WHERE Name='#{treatment_name}'").first
    return "Could not find treatment campaign" if !treatment

    results[:testSuccesses] = treatment[metrics.first]
    results[:testFailures] = treatment[metrics.last] - treatment[metrics.first]

    return results
  end
end