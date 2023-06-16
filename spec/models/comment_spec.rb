require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }

  it 'is valid with valid attributes' do
    comment = build(:comment, post: post)
    expect(comment).to be_valid
  end

  it 'is not valid without a name' do
    comment = build(:comment, name: nil, post: post)
    expect(comment).to_not be_valid
  end

  it 'is not valid without a name' do
    comment = build(:comment, comment: nil, post: post)
    expect(comment).to_not be_valid
  end

  it 'belongs to a post' do
    comment = build(:comment, post: post)
    expect(comment.post).to eq(post)
  end
end
