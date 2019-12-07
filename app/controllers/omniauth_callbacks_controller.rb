class OmniauthCallbacksController < Devise::OmniauthCallbacksController
   
    # def google_oauth2
    #     @user = User.from_omniauth(request.env["omniauth.auth"])
    #     if @user.persisted?
    #         sign_in @user # what is following doing?:, :event => :authentication #this will throw if @user is not activated
    #         set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    #     else
    #         session["devise.google_data"] = request.env["omniauth.auth"]
    #     end
    #     redirect_to user_path(@user)
    # end

    def google_oauth2
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end

  end