class HomeBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String linkUrl;
  final int sortOrder;

  const HomeBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.linkUrl,
    required this.sortOrder,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: '${json['id'] ?? ''}',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      linkUrl: json['linkUrl'] ?? '',
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder']
          : int.tryParse('${json['sortOrder'] ?? 0}') ?? 0,
    );
  }
}
