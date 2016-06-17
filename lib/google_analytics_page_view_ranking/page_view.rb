module GoogleAnalyticsPageViewRanking
  class PageView < ActiveRecord::Base
    extend Enumerize

    belongs_to :item, polymorphic: true

    enumerize :period_type, in: [:daily, :weekly, :monthly]

    validates :item_type, uniqueness: { scope: [:item_id, :period_type] }
  end
end
