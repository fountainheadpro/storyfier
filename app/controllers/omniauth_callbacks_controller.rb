class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter

    @user = resource_class.find_for_twitter_oauth(request.env["omniauth.auth"], request.ip)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Twitter"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def facebook
    @user = resource_class.find_for_facebook_oauth(request.env["omniauth.auth"], request.ip)

    if @user.persisted?
      #flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Facebook"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end

  def linkedin
    @user = resource_class.find_for_facebook_oauth(request.env["omniauth.auth"], request.ip)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Linkedin"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end

end