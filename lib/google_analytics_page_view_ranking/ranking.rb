require 'active_support/concern'

module GoogleAnalyticsPageViewRanking
  module Rannking
    extend ActiveSupport::Concern

    included do
      has_many :rankings, class_name: 'PageView', as: :item, dependent: :destroy

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
        item_type = model_name.element.to_sym
        analytics = GoogleAnalytics.new
        analytics.ranking(item_type, start_date, end_date).results.each do |value|
          target_id = value.page_path.slice(/\d+\z/)
          if target = find_by(id: target_id)
            page_view = target.rankings.build
            page_view.period_type = period_type
            page_view.page_view = value.pageviews
            page_view.save!
          end
        end
      end
    end
  end
end
