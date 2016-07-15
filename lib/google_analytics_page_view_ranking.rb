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
        log "[GoogleAnalyticsPageViewRanking] Start #{klass}"
        log "[GoogleAnalyticsPageViewRanking] Start #{klass}: daily"
        klass.refresh_daily_ranking!
        log "[GoogleAnalyticsPageViewRanking] Start #{klass}: weekly"
        klass.refresh_weekly_ranking!
        log "[GoogleAnalyticsPageViewRanking] Start #{klass}: monthly"
        klass.refresh_monthly_ranking!
      end
    end
  end

  def self.log(str)
    if defined?(Rails)
      Rails.logger.info str
    else
      puts str
    end
  end
end
