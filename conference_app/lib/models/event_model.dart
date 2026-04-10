class EventModel {
  final String id;
  final String titleEn;
  final String titleZh;
  final String descriptionEn;
  final String descriptionZh;
  final String locationEn;
  final String locationZh;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String organizerEn;
  final String organizerZh;
  final List<String> tags;
  final bool isFeatured;
  final int maxAttendees;
  final int currentAttendees;
  final String status; // 'draft', 'published', 'ended'

  const EventModel({
    required this.id,
    required this.titleEn,
    required this.titleZh,
    required this.descriptionEn,
    required this.descriptionZh,
    required this.locationEn,
    required this.locationZh,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.organizerEn = '',
    this.organizerZh = '',
    this.tags = const [],
    this.isFeatured = false,
    this.maxAttendees = 0,
    this.currentAttendees = 0,
    this.status = 'published',
  });

  String get dateRangeStr {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (startDate.month == endDate.month) {
      return '${months[startDate.month - 1]} ${startDate.day}-${endDate.day}, ${startDate.year}';
    }
    return '${months[startDate.month - 1]} ${startDate.day} - ${months[endDate.month - 1]} ${endDate.day}, ${endDate.year}';
  }

  int get remainingSpots => maxAttendees > 0 ? maxAttendees - currentAttendees : -1;
}
