json.post do
  json.id @post.id
  json.title @post.title
  json.text @post.text
end