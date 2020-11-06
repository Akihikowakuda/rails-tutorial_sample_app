module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #sessionメソッドで作成した一時cookiesは自動的に暗号化される
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      # ≒ @current_user = @current_user || User.find_by(id: session[:user_id])
      # @current_userがnillならUserオブジェクトを代入する
    end
  end

  # ユーザーがログインしていればtrue、そのたならfalse
  def logged_in?
    !current_user.nil?
  end

  #現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
