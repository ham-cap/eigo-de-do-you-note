module SessionsSupport
  def log_in_as(user)
    OmniAuth.configure do |config|
      config.test_mode = true
      config.mock_auth[:google_oauth2] =
        OmniAuth::AuthHash.new({
          provider: user.provider,
          uid: user.uid,
          info: {
            name: user.name,
            email: user.email,
            image: user.image
          }
        })
    end

    visit root_path
    click_on 'Googleでログイン', match: :first
  end

  def log_out
    visit log_out_path
  end
end
