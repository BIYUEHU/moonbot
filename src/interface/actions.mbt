///|
pub(all) struct GetLatestEventsRequest {
  limit : Int64
  timeout : Int64
}

///|
pub type GetLatestEventsResponse = Array[String]

///|
pub(all) struct GetSupportedActionsRequest {}

///|
pub type GetSupportedActionsResponse = Array[String]

///|
pub(all) struct GetStatusRequest {}

///|
pub(all) struct GetStatusResponse {
  good : Bool
  bots : Array[BotStatus]
}

///|
pub(all) struct GetVersionRequest {}

///|
pub(all) struct GetVersionResponse {
  impl_ : String
  version : String
  onebot_version : String
}

///|
pub(all) enum MessageSendRequest {
  Private(MessageSendPrivate)
  Group(MessageSendGroup)
  Guild(MessageSendChannel)
}

///|
pub(all) struct MessageSendPrivate {
  user_id : String
  message : Message
}

///|
pub(all) struct MessageSendGroup {
  group_id : String
  message : Message
}

///|
pub(all) struct MessageSendChannel {
  guild_id : String
  channel_id : String
  message : Message
}

///|
pub(all) struct MessageSendResponse {
  message_id : String
  time : Float
}

///|
pub(all) struct MessageDeleteRequest {
  message_id : String
}

///|
pub(all) struct MessageDeleteResponse {}

///|
pub(all) struct GetSelfInfoRequest {}

///|
pub(all) struct GetSelfInfoResponse {
  user_id : String
  user_name : String
  user_displayname : String
}

///|
pub(all) struct GetUserInfoRequest {
  user_id : String
}

///|
pub(all) struct GetUserInfoResponse {
  user_id : String
  user_name : String
  user_displayname : String
  user_remark : String
}

///|
pub(all) struct GetFriendListRequest {}

///|
pub type GetFriendListReponse = Array[GetUserInfoResponse]

///|
pub(all) struct GetGroupInfoRequest {
  group_id : String
}

///|
pub(all) struct GetGroupInfoResponse {
  group_id : String
  group_name : String
}

///|
pub(all) struct GetGroupListRequest {}

///|
pub type GetGroupListResponse = Array[GetGroupInfoResponse]

///|
pub(all) struct GetGroupMemberInfoRequest {
  group_id : String
  user_id : String
}

///|
pub(all) struct GetGroupMemberInfoResponse {
  user_id : String
  user_name : String
  user_displayname : String
}

///|
pub(all) struct GetGroupMemberListRequest {
  group_id : String
}

///|
pub type GetGroupMemberListResponse = Array[GetGroupMemberInfoResponse]

///|
pub(all) struct SetGroupNameRequest {
  group_id : String
  group_name : String
}

///|
pub(all) struct SetGroupNameResponse {}

///|
pub(all) struct LeaveGroupRequest {
  group_id : String
}

///|
pub(all) struct LeaveGroupResponse {}

///|
pub(all) struct GetGuildInfoRequest {
  guild_id : String
}

///|
pub(all) struct GetGuildInfoResponse {
  guild_id : String
  guild_name : String
}

///|
pub(all) struct GetGuildListRequest {}

///|
pub type GetGuildListResponse = Array[GetGuildInfoResponse]

///|
pub(all) struct SetGuildNameRequest {
  guild_id : String
  guild_name : String
}

///|
pub(all) struct SetGuildNameResponse {
  user_id : String
  user_name : String
  user_displayname : String
}

///|
pub(all) struct GetGuildMemberInfoRequest {
  guild_id : String
  user_id : String
}

///|
pub(all) struct GetGuildMemberInfoResponse {
  user_id : String
  user_name : String
  user_displayname : String
}

///|
pub(all) struct GetGuildMemberListRequest {
  guild_id : String
  user_id : String
}

///|
pub type GetGuildMemberListResponse = Array[GetGuildMemberInfoResponse]

///|
pub(all) struct LeaveGuildRequest {
  guild_id : String
}

///|
pub(all) struct LeaveGuildResponse {}

///|
pub(all) struct GetChannelInfoRequest {
  channel_id : String
  guild_id : String
}

///|
pub(all) struct GetChannelInfoResponse {
  channel_id : String
  channel_name : String
}

///|
pub(all) struct GetChannelListRequest {
  guild_id : String
  joined_only : Bool
}

///|
pub type GetChannelListResponse = Array[GetChannelInfoResponse]

///|
pub(all) struct SetChannelNameRequest {
  channel_id : String
  guild_id : String
  channel_name : String
}

///|
pub(all) struct SetChannelNameResponse {}

///|
pub(all) struct GetChannelMemberInfoRequest {
  channel_id : String
  guild_id : String
  user_id : String
}

///|
pub(all) struct GetChannelMemberInfoResponse {
  user_id : String
  user_name : String
  user_displayname : String
}

///|
pub(all) struct GetChannelMemberListRequest {
  channel_id : String
  guild_id : String
}

///|
pub type GetChannelMemberListResponse = Array[GetChannelMemberInfoResponse]

///|
pub(all) struct LeaveChannelRequest {
  channel_id : String
  guild_id : String
}

///|
pub(all) struct LeaveChannelResponse {}

///|
pub(all) struct UploadFileUrl {
  name : String
  headers : Map[String, String]?
  url : String
  sha256 : String?
}

///|
pub(all) struct UploadFilePath {
  name : String
  path : String
  sha256 : String?
}

///|
pub(all) struct UploadFileData {
  name : String
  data : Bytes
  sha256 : String?
}

///|
pub(all) enum UploadFileRequest {
  Url(UploadFileUrl)
  Path(UploadFilePath)
  Data(UploadFileData)
}

///|
pub(all) struct UploadFileResponse {
  file_id : String
}

///|
pub(all) struct UploadFileFragmentedPrepareRequest {
  name : String
  total_size : Int64
}

///|
pub(all) struct UploadFileFragmentedPrepareResponse {
  file_id : String
}

///|
pub(all) struct UploadFileFragmentedTransferRequest {
  file_id : String
  sha256 : String
}

///|
pub(all) struct UploadFileFragmentedTransferResponse {}

///|
pub(all) struct UploadFileFragmentedFinishRequest {
  file_id : String
  sha256 : String
}

///|
pub(all) struct UploadFileFragmentedFinishResponse {
  file_id : String
}

///|
pub(all) enum UploadFileFragmentedRequest {
  Prepare(UploadFileFragmentedPrepareRequest)
  Transfer(UploadFileFragmentedTransferRequest)
  Finish(UploadFileFragmentedFinishRequest)
}

///|
pub(all) enum UploadFileFragmentedResponse {
  Prepare(UploadFileFragmentedPrepareResponse)
  Transfer(UploadFileFragmentedTransferResponse)
  Finish(UploadFileFragmentedFinishResponse)
}

///|
pub(all) enum GetFileType {
  Url
  Path
  Data
}

///|
pub(all) struct GetFileRequest {
  file_id : String
  type_ : GetFileType
}

///|
pub(all) struct GetFileUrlResponse {
  name : String
  headers : Map[String, String]?
  url : String
  sha256 : String?
}

///|
pub(all) struct GetFilePathResponse {
  name : String
  path : String
  sha256 : String?
}

///|
pub(all) struct GetFileDataResponse {
  name : String
  data : Bytes
  sha256 : String?
}

///|
pub(all) enum GetFileResponse {
  Url(GetFileUrlResponse)
  Path(GetFilePathResponse)
  Data(GetFileDataResponse)
}

///|
pub(all) struct GetFileFragmentedPrepareRequest {
  file_id : String
}

///|
pub(all) struct GetFileFragmentedPrepareResponse {
  name : String
  total_size : Int64
  sha256 : String
}

///|
pub(all) struct GetFileFragmentedTransferRequest {
  file_id : String
  offset : Int64
  size : Int64
}

///|
pub(all) struct GetFileFragmentedTransferResponse {
  data : Bytes
}

///|
pub(all) enum GetFileFragmentedRequest {
  Prepare(GetFileFragmentedPrepareRequest)
  Transfer(GetFileFragmentedTransferRequest)
}

///|
pub(all) enum GetFileFragmentedResponse {
  Prepare(GetFileFragmentedPrepareResponse)
  Transfer(GetFileFragmentedTransferResponse)
}
