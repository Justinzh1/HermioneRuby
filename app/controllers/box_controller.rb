require 'rest-client'
require 'boxr'

class BoxController < ApplicationController

    def save_box_token(access, refresh)
        byebug
        BoxToken.create(:token => refresh)
    end

    def trigger_upload

    end

    def index
        @code = params[:code]
        @state = params[:state]
        expireTime = session[:expiration]

        # Existing client is valid

        byebug
        @@client ||= nil
        if !expireTime.nil? and Time.now < expireTime and !@@client.nil?
            @client = @@client
        end

        if !@code.nil?
            body = "grant_type=authorization_code&code=" + @code + "&client_id=" + ENV['CLIENT_ID'] + "&client_secret=" + ENV['CLIENT_SECRET'] + "&redirect_uri=http://localhost:3000/box" 
            res = HTTP.headers("Content-Type":"application/x-www-form-urlencoded").post('https://api.box.com/oauth2/token', :body => body)
            response = JSON.parse(res.to_s)
            refresh_token = response['refresh_token']
            access_token = response['access_token']
            expire = response['expires_in']

            if refresh_token.nil? or access_token.nil? or expire.nil?
                render :index
                return
            end

            token_refresh_callback = lambda {|access, refresh, identifier| save_box_token(access, refresh)}
            @@client = Boxr::Client.new(access_token,
                          refresh_token: refresh_token,
                          client_id: ENV['CLIENT_ID'],
                          client_secret: ENV['CLIENT_SECRET'],
                          &token_refresh_callback)
            session[:expiration] = Time.now + expire.to_i
        end
    end

    def auth 
        # todo validate state
        res = HTTP.follow.get('https://account.box.com/api/oauth2/authorize', :params => {
                response_type: 'code',
                client_id: ENV['CLIENT_ID'],
                redirect_uri: "http://localhost:3000/box",
                state: 'pineapple'
            })
        redirect_to res.uri.to_s
    end
end
