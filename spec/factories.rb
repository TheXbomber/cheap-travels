FactoryBot.define do
    factory :user do
        name {"Test"}
        email {"test@email.com"}
        password {"1234567"}
        encrypted_password {"abcdefghilmnopqrstuvz"}
        banned {false}
    end

    factory :review do
        body {"Body"}
        rating {3}
        place {"Paris"}
        user_id {1}
    end
end