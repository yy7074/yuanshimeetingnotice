import '../models/event_model.dart';
import '../models/session_model.dart';
import '../models/speaker_model.dart';
import '../models/user_model.dart';

class DataService {
  static const apscvir2026EventId = '20262026-0611-4614-8614-000000029839';

  // Local fallback user for offline/dev auth only.
  static const demoUser = UserModel(
    id: 'user_001',
    email: 'demo@apscvir.org',
    nameEn: 'APSCVIR Delegate',
    nameZh: 'APSCVIR 参会代表',
    titleEn: 'Conference Attendee',
    titleZh: '大会参会者',
    organizationEn: 'APSCVIR 2026',
    organizationZh: 'APSCVIR 2026',
    avatarUrl: '',
    role: UserRole.vip,
  );

  static final List<EventModel> events = [
    EventModel(
      id: apscvir2026EventId,
      titleEn:
          '20th Annual Scientific Meeting of Asia Pacific Society of Cardiovascular and Interventional Radiology',
      titleZh: '第20届亚太心血管与介入放射学会年会',
      descriptionEn:
          'Official APSCVIR 2026 meeting information for Suzhou, including registration, program, venue, and attendee services. Faculty and detailed agenda content should be checked on the official website.',
      descriptionZh:
          'APSCVIR 2026 苏州大会官方会议信息，包含注册、日程、会场及参会服务；专家与详细日程以官方网页实时更新为准。',
      locationEn:
          'Suzhou International Expo Centre, 688 E. Suzhou Avenue, Suzhou Industrial Park, Suzhou, Jiangsu Province, China',
      locationZh: '中国江苏省苏州市苏州工业园区苏州大道东688号 苏州国际博览中心',
      imageUrl:
          'http://139.129.23.105:3201/uploads/events/apscvir-2026-meeting.png',
      startDate: DateTime(2026, 6, 11),
      endDate: DateTime(2026, 6, 14),
      organizerEn: 'APSCVIR 2026 Organizing Committee',
      organizerZh: 'APSCVIR 2026 组织委员会',
      tags: ['APSCVIR', 'Interventional Radiology', 'Cardiovascular', 'Suzhou'],
      isFeatured: true,
      currentAttendees: 0,
      maxAttendees: 0,
    ),
  ];

  static final List<SpeakerModel> speakers = [];

  static List<SessionModel> getSessions(String eventId) {
    return [];
  }
}
