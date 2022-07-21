#require 'user'
require 'rails_helper'

# RSpec.describe User do
#     describe ".ban_user" do
#         user = User.new(1, "Test", "test@test.com", "user", false)
#         #before(:each){get :ban_user, {:uid=>@user.id}}
#         it "ban a user" do
#             #id=params[:uid]
#             id=user.id
#             allow(User).to receive(:find).with(id).and_return(user)
#             user.ban_user
#             expect(user.banned).to eq(true)
#             #allow(@user).to receive(:update).and_return(true)
#             #allow(@user).to receive(:save).and_return(true)
#             #expect{@user.save!}.to change{User.banned}.to eq(true)
#         end
#     end
    
#     # describe ".promote_to_moderator" do
#     #     before(:each){@user=User.new(1, "Test", "test@test.com", "user", false)}
#     #     #before(:each){get :ban_user, {:uid=>@user.id}}
#     #     it "ban a user" do
#     #         #id=params[:uid]
#     #         id=@user.id
#     #         allow(User).to receive(:find).with(id).and_return(@user)
#     #         @user.ban_user
#     #         expect(@user.banned).to eq(true)
#     #         #allow(@user).to receive(:update).and_return(true)
#     #         #allow(@user).to receive(:save).and_return(true)
#     #     end
#     # end
# end

RSpec.describe User, type: :model do
	subject {User.new(name: "Test", email: "test@test.com")}
    context 'Attributes' do
        context 'id' do
            it 'should have an id' do
                expect(subject).to respond_to(:id)
            end

            it 'should be invalid without a user_id' do
                subject.id=nil
                expect(subject).to be_invalid
            end

            it 'should be a number' do
                subject.id='a'
                expect(subject).to be_invalid
            end
        end
		
		context 'name' do
			it 'should not be empty' do
				expect(subject).to respond_to(:name)
			end
			
			it 'should be invalid without a name' do
				subject.name = nil
				expect(subject).to be_invalid
			end
		end

		context 'email' do
			it 'should not be empty' do
				expect(subject).to respond_to(:email)
			end
			
			it 'should not be invalid without a name' do
				subject.email = nil
				expect(subject).to be_invalid
			end

			# it 'should be a valid email' do
			# 	expect(subject).to match(/\A\w+@\w+\.\w+\Z/)
			# end
		end

		context 'password' do
			it 'should not be empty' do
				expect(subject).to respond_to(:encrypted_password)
			end
		end

		context 'role' do
			it 'should have a role' do
				subject.role = nil
				expect(subject).to be_invalid
			end
			
			it 'should be either user, moderator or admin' do
				expect(subject.role).to match(/user|moderator|admin/)
			end
		end

		context 'telephone' do	
			it 'should be a number' do
				if subject.tel
					expect(subject.tel).to match(/\A(\d+)*\Z/)
				end
			end
		end

		context 'banned' do
			it 'should not be nil' do
				subject.banned = nil
				expect(subject).to be_invalid
			end

			it 'should be a boolean' do
				expect(subject.banned).to be_in([true, false])
			end
		end

		context 'favourites' do
			it 'should not be nil' do
				subject.favourites = nil
				expect(subject).to be_invalid
			end
		end
	end
end