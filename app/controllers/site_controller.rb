class SiteController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_user
    layout 'site'

    private
        def set_current_user
            Thread.current[:current_administrator] = nil
            Thread.current[:current_user] = current_user
        end
end