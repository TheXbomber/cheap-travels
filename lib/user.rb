class User 
    attr_accessor :banned, :id

    def initialize(id, name, email, role, banned)
        @id=id
        @name=name
        @email=email
        @role=role
        @banned=banned
    end

    def ban_user
        #id=params[:uid]
        @user = User.find(id)
        @user.banned=true
        #@user.update(banned:true)
        #@user.save
        #redirect_back(fallback_location: root_path)
    end
end
