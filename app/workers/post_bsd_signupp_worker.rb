class PostBsdSignupWorker
  include Sidekiq::Worker

  def perform(signup_id)
    Signup.find(signup_id).send_to_bsd!
  end
end
