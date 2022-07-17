require 'rails_helper'

RSpec.describe Review, type: :model do
    subject {Review.new(body: "Body", rating: 3, place: "Paris", user_id: 1)}
    context 'Attributes' do
        context 'user_id' do
            it 'should have a place ' do
                expect(subject).to respond_to(:user_id)
            end

            it 'should be invalid without a user id' do
                subject.user_id=nil
                expect(subject).to be_invalid
            end

            it 'should be a number' do
                subject.user_id='a'
                expect(subject).to be_invalid
            end
        end

        context 'place' do
            it 'should have a place attribute' do
                expect(subject).to respond_to(:place)
            end

            it 'should be invalid without a place' do
                subject.place=nil
                expect(subject).to be_invalid
            end

            it 'should have only word' do
                subject.place='1'
                expect(subject).to be_invalid
            end
        end

        context 'rating' do
            it 'should have a rating attribute' do
                expect(subject).to respond_to(:rating)
            end

            it 'should be invalid without a rating' do
                subject.rating=nil
                expect(subject).to be_invalid
            end

            it 'should be greater than or equal to 1' do
                subject.rating=0
                expect(subject).to be_invalid
            end

            it 'should be less than or equal to 5' do
                subject.rating=6
                expect(subject).to be_invalid
            end
        end

        context 'body' do
            it 'should have a body attribute' do
                expect(subject).to respond_to(:body)
            end
        end
    end
end