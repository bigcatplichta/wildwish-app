class User < ApplicationRecord
  extend Devise::Models
  include UsersHelper
  
  # associations
  has_one :donor
  has_one :keeper
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # create methods
  # this overrides ActiveRecords 'build'_donor method
  # make sure donor is set with attribute names according to user fields
  # provides gracefull fallback if donor already exists
  def set_donor
    if self.donor.nil?
    donor = self.build_donor(
      first_name: self.first_name, 
      last_name: self.last_name, 
      email: self.email
    )
    donor.save
    end
    self.donor # ensure the donor is returned regardless if it was created or previously existed
  end

  # method copy/pasted, check that it works and tweak
  # Google oauth authentication
  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  def self.from_omniauth(auth)
    # Either create a User record or update it based on the provider (Google) and the UID   
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.token = auth.credentials.token
      # user.expires = auth.credentials.expires
      # user.expires_at = auth.credentials.expires_at
      # user.refresh_token = auth.credentials.refresh_token
    end
  end

end
