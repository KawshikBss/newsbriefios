class ArticleModel {
  int? id;
  String? title;
  String? summary;
  String? detailedSummary;
  String? detailText;
  int? imageCount;
  List<String>? images;
  String? biasImage;
  String? biasText;
  String? timeNow;
  String? credibilityScore;
  String? mediaBias;
  int? commentsCount;
  int? shares;
  bool? savedBookmark;

  ArticleModel({
    this.id,
    this.title,
    this.summary,
    this.detailedSummary,
    this.detailText,
    this.imageCount,
    this.images,
    this.biasImage,
    this.biasText,
    this.timeNow,
    this.credibilityScore,
    this.mediaBias,
    this.commentsCount,
    this.shares,
    this.savedBookmark,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    try {
      if (json['images'] != null && json['images'] is List) {
        images = List<String>.from(
          json['images'].map((image) => image['url'] as String),
        );
      }
    } catch (error) {
      print('Error parsing images: $error');
    }
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      detailedSummary: json['detailed_summary'],
      detailText: json['detail_text'],
      imageCount: json['images_count'],
      images: images,
      biasImage: json['bias_image'],
      biasText: json['bias_text'],
      timeNow: json['time_now'],
      credibilityScore: '${json['credibility_score']}',
      mediaBias: json['media_bias'],
      commentsCount: json['comments_count'],
      shares: json['shares'],
      savedBookmark: json['saved_bookmark'],
    );
  }
}
