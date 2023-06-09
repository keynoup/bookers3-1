class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy, foreign_key:"user_id"
  has_one_attached :profile_image

  has_many :favorites, dependent: :destroy

  has_many :post_comments, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key:"follower_id",dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key:"followed_id",dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  def follow(user_id)
  relationships.create(followed_id: user_id)
  #=> <#relatioships id: nil, follwer_id: current_userのid, followed_id: 引数user_idの中身>
  end


  #　フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  #フォローしていればtrueを返す
  def following?(user)
    followings.include?(user)
  end


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  validates :introduction, length: { maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end