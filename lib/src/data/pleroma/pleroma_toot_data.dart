import 'package:stele/src/data/pleroma/pleroma_emoji_reactions.dart';

class PleromaData {
  final Map<String, dynamic> content;
  final String
  contentType; // Should proably be an enum but idk what this will be
  final int conversationId;
  final String? directConversationId;
  final List<PleromaEmojiReaction> emojiReactions;
  final DateTime? expiresAt;
  final String? accountReplyingTo;
  final bool isLocal;
  final bool parentIsVisible;
  final String? pinnedAt;
  final Map<String, dynamic>? quote;
  final String? quoteUrl;
  final bool isQuoteVisible;
  final int quoteCount;
  final Map<String, dynamic> spolierText;
  final bool isThreadMuted;

  PleromaData(
      this.content,
      this.contentType,
      this.conversationId,
      this.directConversationId,
      this.emojiReactions,
      this.expiresAt,
      this.accountReplyingTo,
      this.isLocal,
      this.parentIsVisible,
      this.pinnedAt,
      this.quote,
      this.quoteUrl,
      this.isQuoteVisible,
      this.quoteCount,
      this.spolierText,
      this.isThreadMuted);

  factory PleromaData.fromJson(Map<String, dynamic> json) {
    List<PleromaEmojiReaction> emojiReactions = [];
    if (json['emoji_reactions'] != null) {
      for (int i = 0; i < json['emoji_reactions'].length; i++) {
        emojiReactions
            .add(PleromaEmojiReaction.fromJson(json['emoji_reactions'][i]));
      }
    }

    return PleromaData(
      json['content'] ?? {},
      json['content_type'] ?? "",
      json['conversation_id'] ?? -1,
      json['direct_conversation_id'] ?? "",
      emojiReactions,
      DateTime.tryParse(json['expires_at'] ?? ""),
      json['in_reply_to_account_acct'] ?? "",
      json['local'] ?? false,
      json['parent_visible'] ?? false,
      json['pinned_at'] ?? "",
      json['quote'] ?? {},
      json['quote_url'] ?? "",
      json['quote_visible'] ?? false,
      json['quotes_count'] ?? -1,
      json['spoiler_text'] ?? {},
      json['thread_muted'] ?? false,
    );
  }
}
