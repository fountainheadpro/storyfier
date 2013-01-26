require 'uuid'

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :facebook_nickname, :facebook_data, :profile_image_url,
                  :facebook_image_url, :location, :timezone, :facebook_email, :facebook_token,
                  :facebook_token_expiration, :unique_token, :original_user_token, :confirmed_at, :source

  attr_accessor :first_use

  def self.find_for_facebook_oauth(access_token, ip)
    data = access_token[:info]
    user = self.where("(email=?) or (facebook_nickname=?) or (last_sign_in_ip=? and first_name=? and last_name=?)", data[:email], data[:nickname], ip, data[:first_name], data[:last_name] ).first
    if user.present?
      user.facebook_token=access_token[:credentials][:token]
      user.facebook_token_expiration=Time.at(access_token[:credentials][:expires_at]).try(:to_datetime)
      user.profile_image_url ||= data[:image]
      user.facebook_data = access_token[:extra][:raw_info].to_json()
      user.update_attributes(
                                     facebook_email: data[:email],
                                     facebook_nickname: data[:nickname],
                                     facebook_image_url: data[:image],
                                     location: data[:location],
                                     timezone: access_token[:extra][:raw_info][:timezone]
                                    ) unless (user.facebook_nickname)
      ##if access_token[:extra][:raw_info][:birthday].present?
      #  parameter_id = Parameter.where(name: 'date_of_birth').select(:id).first.try(:id)
      #  unless UserValue.find_by_parameter_id_and_user_id(parameter_id, user.id).present?
      #    UserValue.create(user: user, parameter_id: parameter_id, value: self.format_facebook_birthday(access_token[:extra][:raw_info][:birthday]))
      #  end
      #end
      #if access_token[:extra][:raw_info][:gender].present?
      #  parameter_id = Parameter.where(name: 'gender').select(:id).first.try(:id)
      #  unless UserValue.find_by_parameter_id_and_user_id(parameter_id, user.id).present?
      #    UserValue.create(user: user, parameter_id: parameter_id, value: access_token[:extra][:raw_info][:gender])
      #  end
      #end
    else
      user=self.create!({
          first_name: data[:first_name],
          last_name: data[:last_name],
          email: data[:email],
          facebook_email: data[:email],
          facebook_nickname: data[:nickname],
          password: Devise.friendly_token[0,20],
          facebook_data: access_token[:extra][:raw_info].to_json(),
          facebook_image_url: data[:image],
          profile_image_url: data[:image],
          location: data[:location],
          facebook_token: access_token[:credentials][:token],
          facebook_token_expiration: Time.at(access_token[:credentials][:expires_at]).try(:to_datetime),
          timezone: access_token[:extra][:raw_info][:timezone]
      })
      #UserValue.create(user: user, parameter: Parameter.find_by_name('date_of_birth'), value: self.format_facebook_birthday(access_token[:extra][:raw_info][:birthday])) if access_token[:extra][:raw_info][:birthday].present?
      #UserValue.create(user: user, parameter: Parameter.find_by_name('gender'), value: access_token[:extra][:raw_info][:gender]) if access_token[:extra][:raw_info][:gender].present?
    end
    user
  end

  def self.format_facebook_birthday(date)
    date.gsub("/", "-")
  end

  def name
    "#{first_name} #{last_name}"
  end

  def age()
    now = Time.now.utc.to_date
    uv=UserValue.find_by_parameter_and_user_id(Parameter.find_by_name('date_of_birth').id ,id)
    if dob.present?
      dob=uv.value
      return now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1) if dob.present?
    end
    nil
  end

end
