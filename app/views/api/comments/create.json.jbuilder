json.comment do
  json.id @comment.id
  json.body @comment.body
  json.user_display_name @comment.user_display_name
  json.user_name @comment.user_name
  json.created_at @comment.created_at

  json.parent do
    json.id @comment.fetch_comment.id
    json.body @comment.fetch_comment.body
    json.user_display_name @comment.fetch_comment.user_display_name
    json.user_name @comment.fetch_comment.user_name
    json.created_at @comment.fetch_comment.created_at
  end

  json.children @comment.fetch_comments do |child|
    json.id child.id
    json.body child.body
    json.user_display_name child.user_display_name
    json.user_name child.user_name
    json.created_at child.created_at
  end
end

json.errors @comment.errors.full_messages
