module SorceryHelpers
  def login_user(user)
    post login_path, params: { email: user.email, password: user.password }
  end
end

RSpec.configure do |config|
  config.include SorceryHelpers, type: :request
end
