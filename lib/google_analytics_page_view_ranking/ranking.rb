require 'active_support/concern'
require 'google_analytics_page_view_ranking/google_analytics'

module GoogleAnalyticsPageViewRanking
  module Ranking
    extend ActiveSupport::Concern

    included do
      has_many :rankings, class_name: 'GoogleAnalyticsPageViewRanking::PageView', as: :item, dependent: :destroy

      scope :ranking, -> { joins(:rankings).order('page_views.page_view desc') }
      scope :daily_ranking, -> { ranking.where { page_views.period_type == 'daily' } }
      scope :weekly_ranking, -> { ranking.where { page_views.period_type == 'weekly' } }
      scope :monthly_ranking, -> { ranking.where { page_views.period_type == 'monthly' } }

      scope :ranking_list, -> { order(page_views: :desc) }

      scope :top_ranking, -> { limit(15) }
      scope :top_ranking_widget, -> { limit(3) }
    end

    module ClassMethods
      def refresh_daily_ranking!
        start_date = Date.yesterday
        end_date = Date.yesterday
        refresh_ranking!(:daily, start_date, end_date)
      end

      def refresh_weekly_ranking!
        start_date = 1.week.ago
        end_date = Time.current
        refresh_ranking!(:weekly, start_date, end_date)
      end

      def refresh_monthly_ranking!
        start_date = 1.month.ago
        end_date = Time.current
        refresh_ranking!(:monthly, start_date, end_date)
      end

      def refresh_ranking!(period_type, start_date, end_date)
        analytics = GoogleAnalyticsPageViewRanking::GoogleAnalytics.new
        analytics.ranking(google_analytics_page_path_regex, start_date, end_date, google_analytics_fetch_limit).results.each do |value|
          if target = google_analytics_find_item(value)
            page_view = target.rankings.build
            page_view.period_type = period_type
            page_view.page_view = value.pageviews
            page_view.save!
          end
        end
      end

      def google_analytics_page_path_regex
        item_type = model_name.element.to_sym
        "^/#{item_type.to_s.pluralize}/[0-9]+$"
      end

      def google_analytics_find_item(value)
        target_id = value.page_path.slice(/\d+\z/)
        find_by(id: target_id)
      end

      def google_analytics_fetch_limit
        30
      end
    end
  end
end
