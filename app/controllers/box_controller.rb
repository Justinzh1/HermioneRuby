class BoxController < ApplicationController

    def index
    end

    def auth 
        res = HTTP.get('https://account.box.com/api/oauth2/authorize', :params => {

            })
    end
end
