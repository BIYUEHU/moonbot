///|
pub(all) struct MetaConnectEvent {
  detail_type : String
  version : GetVersionResponse
}

///|
pub(all) struct MetaHeartbeatEvent {
  detail_type : String
  interval : Int64
}

///|
pub(all) struct MetaStatusUpdateEvent {
  detail_type : String
  status : GetStatusResponse
}

///|
pub(all) struct MessagePrivateEvent {
  message_id : String
  message : Message
  alt_message : String?
  user_id : String
}

///|
pub(all) struct NoticeFriendIncreaseEvent {
  user_id : String
}

///|
pub(all) struct NoticeFriendDecreaseEvent {
  user_id : String
}

///|
pub(all) struct NoticePirvateMessageDeleteEvent {
  message_id : String
  user_id : String
}

///|
pub(all) struct MessageGroupEvent {
  message_id : String
  message : Message
  alt_message : String?
  group_id : String
  user_id : String
}

///|
pub(all) struct NoticeGroupMemberIncreaseEvent {
  sub_type : MemberIncreaseSubType
  group_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeGroupMemberDecreaseEvent {
  sub_type : MemberDecreaseSubType
  group_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeGroupMessageDeleteEvent {
  sub_type : MessageDeleteSubType
  group_id : String
  user_id : String
  operator_id : String
  message_id : String
}

///|
pub(all) struct MessageChannelEvent {
  message_id : String
  message : Message
  alt_message : String?
  guild_id : String
  channel_id : String
  user_id : String
}

///|
pub(all) struct NoticeGuildMemberIncreaseEvent {
  sub_type : MemberIncreaseSubType
  guild_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeGuildMemberDecreaseEvent {
  sub_type : MemberDecreaseSubType
  guild_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeChannelMemberIncreaseEvent {
  sub_type : MemberIncreaseSubType
  guild_id : String
  channel_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeChannelMemberDecreaseEvent {
  sub_type : MemberDecreaseSubType
  guild_id : String
  channel_id : String
  user_id : String
  operator_id : String
}

///|
pub(all) struct NoticeChannelMessageDeleteEvent {
  sub_type : MessageDeleteSubType
  guild_id : String
  channel_id : String
  user_id : String
  operator_id : String
  message_id : String
}

///|
pub(all) struct NoticeChannelCreateEvent {
  guild_id : String
  channel_id : String
  operator_id : String
}

///|
pub(all) struct NoticeChannelDeleteEvent {
  guild_id : String
  channel_id : String
  operator_id : String
}
