require 'google_analytics_page_view_ranking/version'
require 'google_analytics_page_view_ranking/page_view'
require 'google_analytics_page_view_ranking/ranking'

module GoogleAnalyticsPageViewRanking
  @@target_classes = []

  def self.add_target_class(klass)
    @@target_classes << klass unless @@target_classes.include?(klass)
  end

  def self.target_classes
    @@target_classes
  end

  def self.refresh_all_rankings
    GoogleAnalyticsPageViewRanking::PageView.transaction do
      GoogleAnalyticsPageViewRanking::PageView.delete_all
      self.target_classes.each do |klass|
        klass.refresh_daily_ranking!
        klass.refresh_weekly_ranking!
        klass.refresh_monthly_ranking!
      end
    end
  end
end
