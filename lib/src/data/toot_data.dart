import 'package:stele/src/data/fediverse_account.dart';
import 'package:stele/src/data/pleroma/pleroma_toot_data.dart';

class FediversePost {
  // ignore: todo
  //TODO make dynamic lists/maps into a custom data object. I gain nothing from having these items being inside of a map

  final FediverseAccount _account;
  final List<dynamic>? _application;
  final bool _bookmarked;
  final Map<String, dynamic>?
  _card; // <- this contains information that can be used to create those embeded link things you see on twitter
  final String _content; // maybe make this a dom objec?
  final DateTime _postedAt;
  final List<dynamic> _emojis;

  final bool _favourited;
  final int _favoritedCount;
  final String _id;
  final String? _replyAccountId;
  final String? _replyPostId;
  final String? _language; // maybe this should be an enum

  final List<Map<String, dynamic>> _mediaAttachment;
  final List<FediverseAccount> _mentionedAccounts;
  final bool _isPinned;
  final Map<String, dynamic>? _poll; //??
  final Map<String, dynamic> _reblog;
  final bool _reblogged;
  final int _reblogCount;
  final int _replyCount;
  final bool _isSenstive;
  final String _spolierText;
  final List<dynamic> _tags;
  final String _text;
  final Uri _uri;
  final Uri _url;
  final String
  _visibility; // this should be a enum but idk what the visbiligies are

  final String? _error;

  //Might not always be on a pleroma node on the fediverse
  final PleromaData? _pleromaData;

  FediversePost(
      this._account,
      this._application,
      this._bookmarked,
      this._card,
      this._content,
      this._postedAt,
      this._emojis,
      this._favourited,
      this._favoritedCount,
      this._id,
      this._replyAccountId,
      this._replyPostId,
      this._language,
      this._mediaAttachment,
      this._mentionedAccounts,
      this._isPinned,
      this._pleromaData,
      this._poll,
      this._reblog,
      this._reblogged,
      this._reblogCount,
      this._replyCount,
      this._isSenstive,
      this._spolierText,
      this._tags,
      this._text,
      this._uri,
      this._url,
      this._visibility,
      this._error);

  factory FediversePost.fromJson(Map<String, dynamic> json) {
    List<dynamic> applicationsList = [];
    if (json['application'] != null) {
      for (int i = 0; i < json['application'].length; i++) {
        applicationsList.add(json['application'][i]);
      }
    }

    List<FediverseAccount> mentionedAccounts = [];
    for (int i = 0; i < json['mentions'].length; i++) {
      mentionedAccounts.add(FediverseAccount.mentions(json['mentions'][i]));
    }

    //on cdrom this was a map<String,dynamic>
    List<dynamic> emojiList = [];
    for (int i = 0; i < json['emojis'].length; i++) {
      emojiList.add(json['emojis'][i]);
    }

    List<Map<String, dynamic>> mediaAttachmentsList = [];
    for (int i = 0; i < json['media_attachments'].length; i++) {
      mediaAttachmentsList.add(json['media_attachments'][i]);
    }

    ////on cdrom this was a map<String,dynamic>
    List<dynamic> tagsList = [];
    for (int i = 0; i < json['tags'].length; i++) {
      tagsList.add(json['tags'][i]);
    }

    // List<String> reblogList = [];
    // for(int i =0;i<json['reblog'].length;i++)
    // {
    //   reblogList.add(json['reblog'][i]);
    // }

    PleromaData? pleromaData;
    try {
      pleromaData = PleromaData.fromJson(json['pleroma']);
    } catch (e) {
      print("Could not use pleroma data" + e.toString());
    }

    return FediversePost(
        FediverseAccount.fromJson(json['account']),

        //on mastadon this is a map<string, dynamic>
        applicationsList,
        json['bookmarked'] ?? false,
        json['card'],
        json['content'],
        DateTime.parse(json['created_at']),
        emojiList,
        json['favourited'] ?? false,
        json['favourites_count'],
        json['id'],
        json['in_reply_to_account_id'],
        json['in_reply_to_id'],
        json['language'],
        mediaAttachmentsList,
        mentionedAccounts, // come back to this
        json['muted'] ?? false,
        pleromaData, // come back to this
        json['poll'],
        json['reblog'] ?? {},
        json['reblogged'] ?? false,
        json['reblogs_count'],
        json['replies_count'],
        json['sensitive'],
        json['spoiler_text'],
        tagsList,
        json['text'] ?? "",
        Uri.parse(json['uri']),
        Uri.parse(json['url']),
        json['visibility'],
        json['error']);
  }

  FediverseAccount get getAccount => _account;
  List<dynamic>? get getApplication => _application;
  bool get getIsBookmarked => _bookmarked;
  Map<String, dynamic>? get getCardInformation => _card;
  String get getContent => _content; // maybe make this a dom objec?
  DateTime get getTimePosted => _postedAt;
  List<dynamic> get getEmojis => _emojis;

  bool get getIsFavourited => _favourited;
  int get getFavouritedCount => _favoritedCount;
  String get getId => _id;
  String? get getReplyAccountId => _replyAccountId;
  String? get getReplyPostId => _replyPostId;
  String? get getLanguage => _language; // maybe this should be an enum

  List<Map<String, dynamic>> get getMediaAttachments => _mediaAttachment;
  List<FediverseAccount> get getMentionedAccounts => _mentionedAccounts;
  bool get getIsPinned => _isPinned;
  Map<String, dynamic>? get getPollInfomration => _poll; //??
  Map<String, dynamic> get getReblogContent => _reblog;
  bool get getIsReblogged => _reblogged;
  int get getReblogCount => _reblogCount;
  int get getReplyCount => _replyCount;
  bool get getIsSensitive => _isSenstive;
  String get getIsSpolierText => _spolierText;
  List<dynamic> get getTags => _tags;
  String get getText => _text;
  Uri get getUri => _uri;
  Uri get getUrl => _url;
  String get getVisibility => _visibility;
  String? get getErrorMsg => _error;
  PleromaData? get getPleromaData => _pleromaData;

  bool hasError() => _error == null;
}
