# db/seeds.rb
# Idempotent seeds. Hash passwords with BCrypt and assign encrypted_password directly.

require 'bcrypt'

def encrypted_pw(raw)
  # Use BCrypt directly so we don't depend on Devise.pepper/User.pepper
  BCrypt::Password.create(raw).to_s
end

def ensure_user!(email:, password:, full_name:, major:, year:, avatar_url: nil, bio: nil)
  user = User.find_or_create_by!(email: email) do |u|
    u.encrypted_password = encrypted_pw(password)
  end

  unless user.profile
    user.create_profile!(
      full_name:  full_name,
      major:      major,
      year:       year,
      bio:        bio || "Hi, I'm #{full_name}.",
      avatar_url: avatar_url
    )
  end

  user
end

def ensure_post!(user:, body:)
  Post.where(user: user, body: body).first_or_create!
end

def ensure_comment!(post:, user:, body:)
  Comment.where(post: post, user: user, body: body).first_or_create!
end

def ensure_like!(post:, user:)
  Like.find_or_create_by!(post: post, user: user)
end

def ensure_follow!(follower:, followed:)
  Follow.find_or_create_by!(follower: follower, followed: followed)
end

# ----- Users + Profiles -----
demo  = ensure_user!(
  email: "demo@example.com",  password: "password123",
  full_name: "Demo User",     major: "Computer Science", year: 1,
  avatar_url: "https://example.com/avatar1.png"
)

alice = ensure_user!(
  email: "alice@example.com", password: "password123",
  full_name: "Alice Johnson", major: "Business", year: 2,
  avatar_url: "https://example.com/avatar2.png"
)

bob   = ensure_user!(
  email: "bob@example.com",   password: "password123",
  full_name: "Bob Smith",     major: "Engineering", year: 3,
  avatar_url: "https://example.com/avatar3.png"
)

# ----- Follows -----
ensure_follow!(follower: alice, followed: demo)
ensure_follow!(follower: bob,   followed: demo)
ensure_follow!(follower: demo,  followed: bob)

# ----- Posts / Comments / Likes -----
p1 = ensure_post!(user: demo,  body: "Welcome to our university social network!")
p2 = ensure_post!(user: alice, body: "Looking forward to connecting with classmates.")
p3 = ensure_post!(user: bob,   body: "Any study groups for next week's exam?")

ensure_comment!(post: p1, user: alice, body: "Glad to be here!")
ensure_comment!(post: p1, user: bob,   body: "Hello everyone!")
ensure_comment!(post: p2, user: demo,  body: "Let's set up a meetup.")

ensure_like!(post: p1, user: alice)
ensure_like!(post: p1, user: bob)
ensure_like!(post: p2, user: demo)
ensure_like!(post: p3, user: demo)

puts "Seeding complete: #{User.count} users, #{Profile.count} profiles, #{Post.count} posts, #{Comment.count} comments, #{Like.count} likes, #{Follow.count} follows."


puts "Seeding..."

def ensure_user!(email)
  u = User.find_or_create_by!(email: email) do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
  end
  u.profile.update!(
    full_name: email.split("@").first.titleize,
    major: %w[CST CT CS].sample,
    year: Profile.years.keys.sample,
    bio: "Hello, I'm #{u.profile.full_name}!"
  )
  u
end

u1 = ensure_user!("alice@example.com")
u2 = ensure_user!("bob@example.com")
u3 = ensure_user!("carol@example.com")

posts = [
  u1.posts.create!(body: "Welcome to UniSocial! 🎉"),
  u2.posts.create!(body: "Photo day at campus!"),
  u3.posts.create!(body: "Any study group for CST?")
]

Comment.create!(user: u2, post: posts[0], body: "Congrats!")
Comment.create!(user: u3, post: posts[0], body: "Nice to see this.")
Comment.create!(user: u1, post: posts[2], body: "Count me in.")

Like.create!(user: u1, post: posts[1])
Like.create!(user: u3, post: posts[1])
Like.create!(user: u2, post: posts[0])
Like.create!(user: u1, post: posts[2])

Follow.create!(follower: u1, followed: u2)
Follow.create!(follower: u1, followed: u3)
Follow.create!(follower: u2, followed: u1)

puts "Done."
