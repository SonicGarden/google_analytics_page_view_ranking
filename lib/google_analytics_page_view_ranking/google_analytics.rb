require 'garb'
require 'oauth2'

module GoogleAnalyticsPageViewRanking
  class GoogleAnalytics
    def initialize
      garb_login
      set_target_property(Settings.google.analytics_property_id)
      if @profile.nil?
        fail('Failed get target property')
      end
      self
    end

    def set_target_property(property_id)
      @profile = Garb::Management::Profile.all.detect do |p|
        p.web_property_id == property_id
      end
    end

    def ranking(page_path_regex, start_date, end_date, limit)
      @profile.pageviews(
        limit: limit,
        sort: :pageviews.desc,
        start_date: start_date,
        end_datd: end_date,
        filters: { :page_path.contains => page_path_regex }
      )
    end

    def garb_login
      if (args = [Settings.google.client_id, Settings.google.client_secret, Settings.google.oauth2_access_token, Settings.google.oauth2_refresh_token]).all?(&:present?)
        garb_oauth_login(*args)
      else
        fail 'NO AUTH ENV is given'
      end
    end

    def garb_oauth_login(client_id, client_secret, access_token, refresh_token)
      client = OAuth2::Client.new(
        client_id, client_secret,
        site: 'https://accounts.google.com',
        authorize_url: '/o/oauth2/auth',
        token_url: '/o/oauth2/token'
      )
      Garb::Session.access_token = OAuth2::AccessToken.from_hash(client, access_token: access_token, refresh_token: refresh_token).refresh!
    end

    class Pageviews
      extend Garb::Model
      metrics :pageviews
      dimensions :page_path
    end
  end
end
