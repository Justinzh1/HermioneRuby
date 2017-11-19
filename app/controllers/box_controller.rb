require 'rest-client'

class BoxController < ApplicationController

    def index
        @code = params[:code]
        @state = params[:state]
    end

    def auth 
        res = HTTP.follow.get('https://account.box.com/api/oauth2/authorize', :params => {
                response_type: 'code',
                client_id: ENV['CLIENT_ID'],
                redirect_uir: "http://localhost:3000/box",
                state: 'pineapple'
            })
        redirect_to res.uri.to_s
    end
end
