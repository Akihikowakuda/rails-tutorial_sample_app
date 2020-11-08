require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path  #ログイン用のパスを開く
    assert_template 'sessions/new'  #新しいセッションのフォームが正しく表示されたことを確認s
    post login_path, params: { session: { email: "", password: "" } }  #無効なparamsハッシュをpost
    assert_template 'sessions/new'  #新しいセッションのフォームを再度表示
    assert_not flash.empty?  #フラッシュメッセージが表示されているか確認
    get root_path  #別ページへ一旦移動
    assert flash.empty?  #移動先のページでフラッシュメッセージが表示されていないことを確認
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path #DELETEリクエストをログアウト用パスに発行 destroyが呼ばれる
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
