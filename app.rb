require 'rubygems'
require 'sinatra'
require 'tweetstream'
require 'dotenv'

Dotenv.load

module TwitterTimeline
  class Status
    attr_accessor :text, :user, :source, :created_at, :picture

    def initialize(args)
      @text       = args[:text]
      @user       = args[:user]
      @source     = args[:source]
      @created_at = args[:created_at]
      @picture    = args[:picture]
    end
  end
end

TweetStream.configure do |config|
  config.consumer_key         = ENV['CONSUMER_KEY']
  config.consumer_secret      = ENV['CONSUMER_SECRET']
  config.oauth_token          = ENV['OAUTH_TOKEN']
  config.oauth_token_secret   = ENV['OAUTH_TOKEN_SECRET']
  config.auth_method          = :oauth
end

def collect_tweets
  statuses = []
  TweetStream::Client.new.sample do |status, client|
    statuses << TwitterTimeline::Status.new(
      :text       => status.text,
      :user       => status.user.username, 
      :source     => status.source.match(/>.*</)[0][1..-2], 
      :created_at => status.created_at,
      :picture    => status.user.profile_image_url)
  
    client.stop if statuses.size >= 20
  end
  statuses
end

get '/' do
  @tweets = collect_tweets
  haml :index
end

get '/via_js' do
  haml :via_js
end