Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => 'email, user_photos',
  	:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}

  provider :twitter, TWITTER_APP_ID, TWITTER_SECRET, {:scope => 'email, user_photos'}
  # If you want to also configure for additional login services, they would be configured here.
end
