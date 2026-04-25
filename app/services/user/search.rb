# frozen_string_literal: true

class User::Search
  def initialize(full_name, birthdate, inn)
    @full_name = full_name
    @birthdate = birthdate
    @inn = inn
  end

  def call
    User.find_or_create_by!(inn: @inn) do |user|
      user.full_name = @full_name
      user.birthdate = @birthdate
    end
  end
end
