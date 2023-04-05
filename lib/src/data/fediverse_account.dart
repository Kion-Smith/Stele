class FediverseAccount {
  String? _accountName;
  String? _staticAvatar;
  String? _dynamicAvatar;
  bool? _isBot;
  DateTime? _accountCreated;
  String? _displayName;
  int? _followerCount;
  int? _followingCount;
  String? _dynamicHeaderImage;
  String? _staticHeaderImage;
  String? _id;
  DateTime? _lastPost;
  bool? _isLocked;
  String? _bio;
  /*
  // ignore: todo
  TODO add more information about an account
  */
  Uri? _url;
  String? _username;

  FediverseAccount({
    accountName,
    dynamicAvatar,
    staticAvatar,
    isBot,
    accountCreated,
    displayName,
    followerCount,
    followingCount,
    dynamicHeaderImage,
    staticHeaderImage,
    id,
    lastPost,
    isLocked,
    bio,

    ///
    ///Add in missing data later
    ///
    url,
    username,
  }) {
    _accountName = accountName;
    _dynamicAvatar = _dynamicAvatar;
    _staticAvatar = staticAvatar;
    _isBot = isBot;
    _accountCreated = accountCreated;
    _displayName = displayName;
    _followerCount = followerCount;
    _followingCount = followingCount;
    _dynamicHeaderImage = dynamicHeaderImage;
    _staticHeaderImage = staticHeaderImage;
    _id = id;
    _lastPost = lastPost;
    _isLocked = isLocked;
    _bio = bio;

    ///
    ///Add in missing data later
    ///
    _url = url;
    _username = username;
  }

  factory FediverseAccount.fromJson(Map<String, dynamic> json) {
    return FediverseAccount(
        accountName: json['acct'],
        dynamicAvatar: json['avatar'],
        staticAvatar: json['avatar_static'],
        isBot: json['bot'],
        accountCreated: DateTime.parse(json['created_at']),
        displayName: json['display_name'],
        followerCount: json['followers_count'],
        followingCount: json['following_count'],
        dynamicHeaderImage: json['header'],
        staticHeaderImage: json['header_static'],
        id: json['id'],
        lastPost: DateTime.tryParse(json['last_status_at'] ?? ""),
        isLocked: json['locked'],
        bio: json['note'],
        ///////
        url: Uri.parse(json['url']),
        username: json['username']);
  }

  factory FediverseAccount.mentions(Map<String, dynamic> json) {
    return FediverseAccount(
        accountName: json['acct'],
        id: json['id'],
        url: Uri.parse(json['url']),
        username: json['username']);
  }

  String? get accountName => _accountName;
  String? get displayName => _displayName;
  int? get followerCount => _followerCount;
  int? get followingCount => _followingCount;
  String? get bio => _bio;
  String? get avatar => _dynamicAvatar;
  String? get staticAvatar => _staticAvatar;

  @override
  String toString() {
    return 'account name: $_accountName,avatar:$_dynamicAvatar,'
        'static avatar:$_staticAvatar, is a bot:$_isBot, Created: $_accountCreated,'
        ' displayName:$_displayName, followers: $_followerCount,'
        ' following: $_followingCount, header image:$_dynamicHeaderImage,'
        ' static header image: $_staticHeaderImage, ID:$_id, last post: $_lastPost,'
        'Is account locked: $_isLocked, bio:$_bio';
  }
}
