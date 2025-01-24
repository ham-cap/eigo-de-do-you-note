module LoginSupport
  def log_in_as(user)
    if page.has_selector?('.logout-button')
      click_on 'ログアウト'
    end
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
end
