require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    post = build(:post, user: user)
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post = build(:post, user: user, title: nil)
    expect(post).to_not be_valid
  end

  it 'is not valid without text' do
    post = build(:post, user: user, text: nil)
    expect(post).to_not be_valid
  end

  it 'belongs to a user' do
    post = create(:post, user: user)
    expect(post.user).to eq(user)
  end
end
