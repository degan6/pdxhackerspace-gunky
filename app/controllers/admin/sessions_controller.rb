module Admin
  class SessionsController < ApplicationController
    def new
      head :not_found unless admin_authentication_configured?
    end

    def create
      unless admin_authentication_configured?
        head :not_found
        return
      end

      if sign_in_admin!(params[:password])
        redirect_to logs_path, notice: "Signed in."
      else
        flash.now[:alert] = "Invalid password."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      sign_out_admin!
      redirect_to root_path, notice: "Signed out."
    end
  end
end
