require 'user'

RSpec.describe User do
    describe ".ban_user" do
        before(:each){@user=User.new(1, "Test", "test@test.com", "user", false)}
        #before(:each){get :ban_user, {:uid=>@user.id}}
        it "ban a user" do
            #id=params[:uid]
            id=@user.id
            allow(User).to receive(:find).with(id).and_return(@user)
            @user.ban_user
            expect(@user.banned).to eq(true)
            #allow(@user).to receive(:update).and_return(true)
            #allow(@user).to receive(:save).and_return(true)
            #expect{@user.save!}.to change{User.banned}.to eq(true)
        end
    end
end