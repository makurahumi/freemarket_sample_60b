# frozen_string_literal: true
require "payjp"

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :user_params, only:[:create]
  before_action :validation_phone, only:[:new_phone]
  before_action :validation_address, only:[:new_address]
  before_action :validation_payment, only:[:new_payment]
  before_action :create, only:[:done]
  before_action :create_payment, only:[:done]

  def new
    # Userインスタンス作成
    @user = User.new
    session[:provider] = session[:provider]
    session[:uid] = session[:uid]
  end

  def new_phone
    # userデータをsessionに保存
    session[:nickname] = params[:user][:nickname]
    session[:email] = params[:user][:email]
    session[:password] = params[:user][:password]
    session[:last_name] = params[:user][:last_name]
    session[:first_name] = params[:user][:first_name]
    session[:last_name_kana] = params[:user][:last_name_kana]
    session[:first_name_kana] = params[:user][:first_name_kana]
    session[:birthday] = birthday_join
    @user = User.new
    render :new_phone
  end

  def new_address
    # userデータをsessionに保存
    session[:phone_num] = params[:user][:phone_num]
    @user = User.new
    @user.build_address
    render :new_address
  end

  def new_payment(user_params)
    # addressデータをsessionに保存
    session[:last_name] = params[:user][:last_name_kana]
    session[:first_name] = params[:user][:first_name_kana]
    session[:last_name_kana] = params[:user][:last_name_kana]
    session[:first_name_kana] = params[:user][:first_name_kana]
    session[:zip_code] = user_params[:address_attributes][:zip_code]
    session[:prefecture_id] = user_params[:address_attributes][:prefecture_id]
    session[:city] = user_params[:address_attributes][:city]
    session[:block] = user_params[:address_attributes][:block]
    session[:building_name] = user_params[:address_attributes][:building_name]
    session[:phone_num] = params[:user][:phone_num]
    @user = User.new
    @user.build_address
    render :new_payment
  end

  def create
    # SNS認証登録用
    if session[:provider].present? && session[:uid].present?
      password = Devise.friendly_token.first(7)
      @user = User.create(nickname:session[:nickname],
        nickname: session[:nickname],
        email: session[:email],
        password: password,
        password_confirmation: password,
        birthday: session[:birthday],
        last_name: session[:last_name],
        first_name: session[:first_name],
        last_name_kana: session[:last_name_kana],
        first_name_kana: session[:first_name_kana],
        phone_num: session[:phone_num])
      @user.build_address(
        zip_code: session[:zip_code],
        prefecture_id: session[:prefecture_id],
        city: session[:city],
        block: session[:block],
        building_name: session[:building_name])  
    else
    # メールアドレス登録用
      @user = User.new(
        nickname: session[:nickname],
        email: session[:email],
        password: session[:password],
        password_confirmation: session[:password],
        birthday: session[:birthday],
        last_name: session[:last_name],
        first_name: session[:first_name],
        last_name_kana: session[:last_name_kana],
        first_name_kana: session[:first_name_kana],
        phone_num: session[:phone_num])
      @user.build_address(
        zip_code: session[:zip_code],
        prefecture_id: session[:prefecture_id],
        city: session[:city],
        block: session[:block],
        building_name: session[:building_name])
    end
    if @user.save 
      session[:id] = @user.id
      sign_in User.find(session[:id]) unless user_signed_in?
      else
        render :new
    end
  end

  def done
  sign_in User.find(session[:id]) unless user_signed_in?
  render :done
  end

  def validation_phone
    # 会員情報用バリデーション
    session[:nickname] = params[:user][:nickname]
    session[:email] = params[:user][:email]
    session[:password] = params[:user][:password]
    session[:last_name] = params[:user][:last_name]
    session[:first_name] = params[:user][:first_name]
    session[:last_name_kana] = params[:user][:last_name_kana]
    session[:first_name_kana] = params[:user][:first_name_kana]
    session[:birthday] = birthday_join
    @user = User.new(
      nickname: session[:nickname],
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password],
      birthday: session[:birthday],
      last_name: session[:last_name],
      first_name: session[:first_name],
      last_name_kana: session[:last_name_kana],
      first_name_kana: session[:first_name_kana],
      phone_num: "01234567890")
      render :new_phone unless @user.valid?
  end

  def validation_address
    # 電話番号用バリデーション
    session[:phone_num] = params[:user][:phone_num]
    @user = User.new(
      nickname: session[:nickname],
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password],
      birthday: session[:birthday],
      last_name: session[:last_name],
      first_name: session[:first_name],
      last_name_kana: session[:last_name_kana],
      first_name_kana: session[:first_name_kana],
      phone_num: session[:phone_num])
      @user.build_address(
        # バリデーションをかけるため未入力項目を仮置き
        zip_code: "182-0014",
        prefecture_id: "13",
        city: "調布市",
        block: "柴崎",
        building_name: "ハイツ")  
      render :new_address unless @user.valid?
  end

  def validation_payment
    # 氏名・住所用バリデーション
    session[:last_name] = params[:user][:last_name]
    session[:first_name] = params[:user][:first_name]
    session[:last_name_kana] = params[:user][:last_name_kana]
    session[:first_name_kana] = params[:user][:first_name_kana]
    session[:zip_code] = user_params[:address_attributes][:zip_code]
    session[:prefecture_id] = user_params[:address_attributes][:prefecture_id]
    session[:city] = user_params[:address_attributes][:city]
    session[:block] = user_params[:address_attributes][:block]
    session[:building_name] = user_params[:address_attributes][:building_name]
    session[:phone_num] = params[:user][:phone_num]
    @user = User.new(
      last_name: session[:last_name],
      first_name: session[:first_name],
      last_name_kana: session[:last_name_kana],
      first_name_kana: session[:first_name_kana],
      phone_num: session[:phone_num])
    @user.build_address(
      zip_code: session[:zip_code],
      prefecture_id: session[:prefecture_id],
      city: session[:city],
      block: session[:block],
      building_name: session[:building_name])
      render :new_payment unless @user.valid?
  end

  private

  def birthday_join
    year = params[:birthday]["birthday(1i)"]
    month = params[:birthday]["birthday(2i)"]
    day = params[:birthday]["birthday(3i)"]
    birthday = year.to_s + "-" + month.to_s + "-" + day.to_s
    return birthday
  end

  def user_params
    params.require(:user).permit(
      :nickname,
      :email,
      :password,
      :password_confirmation,
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :birthday,
      :uid,
      :provider,
      :phone_num,
      address_attributes: [:id, :zip_code, :prefecture_id, :city, :block, :building_name]
    )
  end

  def set_user
    @user = User.new(params[:id])
  end

  def set_address
    @user = User.new(params[:id])
    @address = Address.new(params[:id])
  end

  def set_payment
    @user = User.new(params[:id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def create_payment
    Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_PRIVATE_KEY]
    customer = Payjp::Customer.create(
    email: current_user.email,
    card: params['payjp-token'],
    metadata: {user_id: current_user.id}
    )
    @payment = Payment.new(user_id: session[:id], customer_id: customer.id, card_id: customer.default_card)
    if @payment.save
      render :done
    else
      redirect_to action: "new_payment"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end