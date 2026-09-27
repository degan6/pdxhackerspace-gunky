require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @previous_password = ENV["GUNKY_ADMIN_PASSWORD"]
    ENV["GUNKY_ADMIN_PASSWORD"] = "secret-admin-password"
  end

  teardown do
    if @previous_password.nil?
      ENV.delete("GUNKY_ADMIN_PASSWORD")
    else
      ENV["GUNKY_ADMIN_PASSWORD"] = @previous_password
    end
  end

  test "create signs in with valid password" do
    post admin_session_path, params: { password: "secret-admin-password" }
    assert_redirected_to logs_path

    get logs_path
    assert_response :success
  end

  test "create rejects invalid password" do
    post admin_session_path, params: { password: "wrong" }
    assert_response :unprocessable_entity
    assert_includes response.body, "Invalid password"
  end

  test "destroy signs out" do
    post admin_session_path, params: { password: "secret-admin-password" }
    delete admin_session_path
    assert_redirected_to root_path

    get logs_path
    assert_redirected_to admin_sign_in_path
  end
end
