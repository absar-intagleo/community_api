class HomeController < ApplicationController

	def community_api_docs
    redirect_to('/community/docs.html?url=/community_api/api-docs.json')
  end
end
