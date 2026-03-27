class SpeakerModel {
  final String id;
  final String nameEn;
  final String nameZh;
  final String titleEn;
  final String titleZh;
  final String organizationEn;
  final String organizationZh;
  final String bioEn;
  final String bioZh;
  final String avatarUrl;
  final SpeakerCategory category;

  const SpeakerModel({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.titleEn,
    required this.titleZh,
    required this.organizationEn,
    required this.organizationZh,
    this.bioEn = '',
    this.bioZh = '',
    required this.avatarUrl,
    this.category = SpeakerCategory.keynote,
  });
}

enum SpeakerCategory { keynote, vipGuest, research, workshop }

extension SpeakerCategoryLabel on SpeakerCategory {
  String get labelEn => switch (this) {
    SpeakerCategory.keynote => 'KEYNOTE',
    SpeakerCategory.vipGuest => 'VIP GUEST',
    SpeakerCategory.research => 'RESEARCH',
    SpeakerCategory.workshop => 'WORKSHOP',
  };

  String get labelZh => switch (this) {
    SpeakerCategory.keynote => '主旨演讲',
    SpeakerCategory.vipGuest => '特邀嘉宾',
    SpeakerCategory.research => '学术研究',
    SpeakerCategory.workshop => '工作坊',
  };
}
