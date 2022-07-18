class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, :omniauth_providers => %i[facebook google_oauth2 twitter]
    has_many :reviews, dependent: :destroy

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.email = auth.info.email
            user.password = Devise.friendly_token[0, 20]
            # user.bday = auth.info.user_birthday
            user.role = "user"
            user.favourites = ""
            user.name = auth.info.name   # assuming the user model has a name
            # user.image = auth.info.image # assuming the user model has an image
            # If you are using confirmable and the provider(s) you use validate emails, 
            # uncomment the line below to skip the confirmation emails.
            # user.skip_confirmation!
        end
    end

    def self.new_with_session(params, session)
        if session["devise.user_attributes"]
          new(session["devise.user_attributes"], without_protection: true) do |user|
            user.attributes = params
            user.valid?
          end
        else
          super
        end
    end

    #validates :id, :presence => true, :numericality => {:only_integer => true}, :uniqueness => true
    validates :name, :presence => true
    validates :email, :presence => true, :format => {:with => /\A\w+@\w+\.\w+\Z/}
    validates :encrypted_password, :presence => true
    validates :role, :presence => true, :format => {:with => /user|moderator|admin/}
    validates :tel, :format => {:with => /\A(\d+)*\Z/}
    validates :banned, :inclusion => {:in => [true, false]} #, :presence => true 
    #validates :favourites, :presence => true

end