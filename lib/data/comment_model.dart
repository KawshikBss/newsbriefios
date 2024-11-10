class CommentModel {
  int? id;
  int? newsId;
  String? ownerName;
  String? ownerAvatar;
  String? timeNow;
  String? comment;
  String? replyText;
  String? commentsText;
  String? saveText;
  String? reportText;
  int? upvotesCount;
  int? downvotesCount;
  int? repliesCount;
  bool? saved;
  bool? reported;
  List<CommentModel>? replies;

  CommentModel(
      {this.id,
      this.newsId,
      this.ownerName,
      this.ownerAvatar,
      this.timeNow,
      this.comment,
      this.replyText,
      this.commentsText,
      this.saveText,
      this.reportText,
      this.upvotesCount,
      this.downvotesCount,
      this.repliesCount,
      this.saved,
      this.reported,
      this.replies});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    String? ownerName;
    String? ownerAvatar;
    List<CommentModel> replies = [];
    try {
      ownerName = json['owner']['name'];
      ownerAvatar = json['owner']['avatar'];
      if (json['replies'] != null && json['replies'] is List) {
        var jsonData = json['replies'] as List<dynamic>;
        replies = jsonData.map((item) {
          return CommentModel.fromJson(item as Map<String, dynamic>);
        }).toList();
      }
    } catch (error) {
      print('Error parsing replies: $error');
    }
    return CommentModel(
        id: json['id'],
        newsId: json['news_id'],
        ownerName: ownerName,
        ownerAvatar: ownerAvatar,
        timeNow: json['time_now'],
        comment: json['comment'],
        replyText: json['reply_text'],
        commentsText: json['comments_text'],
        saveText: json['save_text'],
        reportText: json['report_text'],
        upvotesCount: json['upvotes_count'],
        downvotesCount: json['downvotes_count'],
        repliesCount: json['replies_count'],
        saved: json['saved'],
        reported: json['reported'],
        replies: replies);
  }
}
