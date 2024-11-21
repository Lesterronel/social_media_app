class AdminController < ApplicationController
    before_action :authenticate_administrator!
    before_action :set_current_administrator
    layout 'site'

    private
        def set_current_administrator
            Thread.current[:current_user] = nil
            Thread.current[:current_administrator] = current_administrator
        end
end