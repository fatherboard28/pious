Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_OAUTH_CLIENT_ID'], ENV['GOOGLE_OAUTH_CLIENT_SECRET']
    #{
    #  scope: 'email, profile',
    #  prompt: 'select_account',
    #  image_aspect_ratio: 'sqaure',
    #  image_size: 50,
    #}
end

