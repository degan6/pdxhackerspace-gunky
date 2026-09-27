module AdminAuthentication
  extend ActiveSupport::Concern

  SESSION_KEY = :gunky_admin

  included do
    helper_method :admin_signed_in?, :admin_authentication_configured?
  end

  def admin_authentication_configured?
    AdminAuthentication.admin_password_configured?
  end

  def admin_signed_in?
    return false unless admin_authentication_configured?

    session[SESSION_KEY] == true
  end

  def require_admin
    return if admin_signed_in?

    if admin_authentication_configured?
      redirect_to admin_sign_in_path, alert: "Admin sign-in is required."
    else
      head :not_found
    end
  end

  def sign_in_admin!(password)
    return false unless AdminAuthentication.password_matches?(password)

    session[SESSION_KEY] = true
    true
  end

  def sign_out_admin!
    session.delete(SESSION_KEY)
  end

  module_function

  def admin_password_configured?
    ENV["GUNKY_ADMIN_PASSWORD"].present?
  end

  def password_matches?(password)
    return false if password.blank?

    configured = ENV["GUNKY_ADMIN_PASSWORD"].to_s
    return false if configured.blank?

    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(password),
      Digest::SHA256.hexdigest(configured)
    )
  end
end
