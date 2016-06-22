# GoogleAnalyticsPageViewRanking

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/google_analytics_page_view_ranking`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_analytics_page_view_ranking'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_analytics_page_view_ranking

## Usage

### Setup Google Client id and secret token
Create google development project on this page
https://console.developers.google.com/
Active 'Google Analytics API'

Set CALLBACK URL example https://www.example.com/oauth2callback

### Get access_token and refresh_token

Open this page and login analytics account

````
https://accounts.google.com/o/oauth2/auth
?response_type=code
&access_type=offline
&client_id=[YOUR CLIENT ID]
&redirect_uri=[CALLBACK URL]
&scope=https://www.googleapis.com/auth/analytics.readonly
````

Copy redirect url and get token

https://www.example.com/oauth2callback?code=[TOKEN]

Get access_token and refresh_token

````
curl -d client_id=[YOUR CLIENT ID] -d client_secret=[YOUR CLIENT SECRET] -d redirect_uri=[CALLBACK URL] -d grant_type=authorization_code -d code=[TOKEN] https://accounts.google.com/o/oauth2/token
````

Response will

````
{
  "access_token" : "ACCESS TOKEN",
  "token_type" : "Bearer",
  "expires_in" : 3600,
  "refresh_token" : "REFRESH TOKEN"
}%    
````

And set tokens on settings.yml

````
google:
  client_id: '[GOOGLE CLIENT ID]'
  client_secret: '[GOOGLE CLIENT SECRET]'
  oauth2_access_token: '[ACCESS TOKEN]'
  oauth2_refresh_token: '[REFRESH TOKEN]'
  analytics_property_id: '[ANALYTICS PROPERTY ID]' # ex) UA-XXXXXXXX-1
````

### Setup your model

````
class Article < ActiveRecord::Base
  include GoogleAnalyticsPageViewRanking::Ranking
end
````

Fetch data from analytics and create record. Open rails console.

````
> Article.refresh_daily_ranking!
> Article.refresh_weekly_ranking!
> Article.refresh_monthly_ranking!
````

Get Record with ranking order.

````
> Article.daily_ranking
> Article.weekly_ranking
> Article.monthly_ranking
````

### Options

基本設定では、 `/articles/10` というURLを前提にAnalyticsからデータを取得する実装になっている。
`/categories/4/articles/10` というようなURLの場合は以下のメソッドをオーバーライドする

````
class Article < ActiveRecord::Base
  # ...

  # Override for GoogleAnalyticsPageViewRanking
  def self.google_analytics_page_path_regex
    "^/categories/[0-9]+/articles/[0-9]+$"
  end
end
````

また、レコードの指定が数字のIDではない場合は、以下のメソッドをオーバーライドする

````
  def self.google_analytics_find_item(value)
    target_id = value.page_path.split('/').last
    find_by(slug: target_id)
  end
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/google_analytics_page_view_ranking. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
