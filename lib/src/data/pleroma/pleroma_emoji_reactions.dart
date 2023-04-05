class PleromaEmojiReaction
{
  final int count;
  final bool isMyReaction;
  final String name;//basically what reaction is it

  PleromaEmojiReaction(this.count, this.isMyReaction, this.name);


  factory PleromaEmojiReaction.fromJson(Map<String,dynamic> json)
  {
    return PleromaEmojiReaction(
      json['count'],
      json['me'],
      json['name'],
    );
  }
}