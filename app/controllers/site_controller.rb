class SiteController < ApplicationController
    before_action :authenticate_user!
    layout 'site'
end