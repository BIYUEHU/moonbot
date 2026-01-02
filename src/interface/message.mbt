///|
pub(all) enum Message {
  Text(String)
  Mention(String)
  MentionAll
  Image(String)
  Voice(String)
  Audio(String)
  Video(String)
  File(String)
  Location(MessageLocation)
  Reply(MessageReply)
}

///|
pub(all) struct MessageLocation {
  latitude : Float
  longitude : Float
  title : String
  content : String
}

///|
pub(all) struct MessageReply {
  message_id : String
  user_id : String
}
