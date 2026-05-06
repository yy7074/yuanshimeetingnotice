type ApscvirSpeakerSeed = {
  id: string;
  nameEn: string;
  nameZh: string;
  titleEn: string;
  titleZh: string;
  organizationEn: string;
  organizationZh: string;
  bioEn?: string;
  bioZh?: string;
  avatarUrl?: string;
  category: string;
};

type ApscvirSessionSeed = {
  id: string;
  titleEn: string;
  titleZh: string;
  descriptionEn?: string;
  descriptionZh?: string;
  roomEn: string;
  roomZh: string;
  startTime: string;
  endTime: string;
  type: string;
  dayIndex: number;
  sortOrder: number;
  speakerId?: string;
  speakerName?: string;
  speakerTitleEn?: string;
  speakerTitleZh?: string;
};

type ApscvirMaterialSeed = {
  id: string;
  nameEn: string;
  nameZh: string;
  fileUrl: string;
  fileSize: number;
  type: string;
};

export const APSCVIR_2026_EVENT_ID = '20262026-0611-4614-8614-000000029839';

export const APSCVIR_2026_SOURCE_URL =
  'https://www.apscvir2026.com/en/minisite/index/29839';
export const APSCVIR_2026_ABOUT_URL =
  'https://www.apscvir2026.com/en/minisite/content/29839?m=1411156';
export const APSCVIR_2026_PROGRAM_URL =
  'https://www.apscvir2026.com/en/minisite/program-view/29839';
export const APSCVIR_2026_REGISTRATION_URL =
  'https://www.apscvir2026.com/en/minisite/registration/29839';
export const APSCVIR_2026_IMAGE_URL =
  'http://139.129.23.105:3201/uploads/events/apscvir-2026-meeting.png';

export const apscvir2026Event = {
  id: APSCVIR_2026_EVENT_ID,
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
  imageUrl: APSCVIR_2026_IMAGE_URL,
  bannerUrl: APSCVIR_2026_IMAGE_URL,
  startDate: '2026-06-11T00:00:00+08:00',
  endDate: '2026-06-14T23:59:00+08:00',
  organizerEn: 'APSCVIR 2026 Organizing Committee',
  organizerZh: 'APSCVIR 2026 组织委员会',
  tags: ['APSCVIR', 'Interventional Radiology', 'Cardiovascular', 'Suzhou'],
  isFeatured: true,
  maxAttendees: 0,
  status: 'published',
};

export const apscvir2026Speakers: ApscvirSpeakerSeed[] = [
  {
    id: '20262026-0001-4000-8000-000000000001',
    nameEn: 'Gao-Jun Teng',
    nameZh: 'Gao-Jun Teng',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Zhongda Hospital, Southeast University, China',
    organizationZh: 'Zhongda Hospital, Southeast University, China',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/user/2022/11/20221107/2022110708281236415789210.jpg!wx250',
    category: 'keynote',
  },
  {
    id: '20262026-0001-4000-8000-000000000002',
    nameEn: 'Barry T. Katzen',
    nameZh: 'Barry T. Katzen',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Miami Cardiac & Vascular Institute, USA',
    organizationZh: 'Miami Cardiac & Vascular Institute, USA',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    category: 'keynote',
  },
  {
    id: '20262026-0001-4000-8000-000000000003',
    nameEn: 'Robert A. Lookstein',
    nameZh: 'Robert A. Lookstein',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Icahn School of Medicine at Mount Sinai, USA',
    organizationZh: 'Icahn School of Medicine at Mount Sinai, USA',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202511/2025110609103039854621071.png!wx250',
    category: 'keynote',
  },
  {
    id: '20262026-0001-4000-8000-000000000004',
    nameEn: 'Andrew Holden',
    nameZh: 'Andrew Holden',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Auckland Hospital, New Zealand',
    organizationZh: 'Auckland Hospital, New Zealand',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202510/2025102022133586154102793.jpeg!wx250',
    category: 'vip_guest',
  },
  {
    id: '20262026-0001-4000-8000-000000000005',
    nameEn: 'Robert Morgan',
    nameZh: 'Robert Morgan',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: "St George's University Hospitals, UK",
    organizationZh: "St George's University Hospitals, UK",
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202510/2025102022120124791063815.jpeg!wx250',
    category: 'vip_guest',
  },
  {
    id: '20262026-0001-4000-8000-000000000006',
    nameEn: 'Ahmad Alomari',
    nameZh: 'Ahmad Alomari',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: "Boston Children's Hospital, USA",
    organizationZh: "Boston Children's Hospital, USA",
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202512/2025122909313287562109431.png!wx250',
    category: 'research',
  },
  {
    id: '20262026-0001-4000-8000-000000000007',
    nameEn: 'Jiaywei Tsauo',
    nameZh: 'Jiaywei Tsauo',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: "Guangdong Provincial People's Hospital, China",
    organizationZh: "Guangdong Provincial People's Hospital, China",
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202603/2026032921352459864103127.png!wx250',
    category: 'workshop',
  },
  {
    id: '20262026-0001-4000-8000-000000000008',
    nameEn: 'John Kaufman',
    nameZh: 'John Kaufman',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Interventional Radiology Clinic, USA',
    organizationZh: 'Interventional Radiology Clinic, USA',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202603/2026032921364059246311078.jpeg!wx250',
    category: 'workshop',
  },
  {
    id: '20262026-0001-4000-8000-000000000009',
    nameEn: 'Anne Roberts',
    nameZh: 'Anne Roberts',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn:
      'University of California, San Diego (UCSD) School of Medicine, USA',
    organizationZh:
      'University of California, San Diego (UCSD) School of Medicine, USA',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202603/2026032921104784236795110.jpeg!wx250',
    category: 'research',
  },
  {
    id: '20262026-0001-4000-8000-000000000010',
    nameEn: 'Luke Han Wei Toh',
    nameZh: 'Luke Han Wei Toh',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: "KK Women's and Children's Hospital, Singapore",
    organizationZh: "KK Women's and Children's Hospital, Singapore",
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/42838/202510/2025102022130210542861739.jpeg!wx250',
    category: 'research',
  },
  {
    id: '20262026-0001-4000-8000-000000000011',
    nameEn: 'Riad Salem',
    nameZh: 'Riad Salem',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Northwestern Medicine, USA',
    organizationZh: 'Northwestern Medicine, USA',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    category: 'keynote',
  },
  {
    id: '20262026-0001-4000-8000-000000000012',
    nameEn: 'Masatoshi Kudo',
    nameZh: 'Masatoshi Kudo',
    titleEn: 'Faculty',
    titleZh: '大会嘉宾',
    organizationEn: 'Kindai University Faculty of Medicine, Japan',
    organizationZh: 'Kindai University Faculty of Medicine, Japan',
    bioEn: 'Listed on the official APSCVIR 2026 Faculty page.',
    bioZh: 'APSCVIR 2026 官方 Faculty 页面列名嘉宾。',
    avatarUrl:
      'https://files.sciconf.cn/master/365/35169/202504/2025041609320341089723615.jpg!wx250',
    category: 'keynote',
  },
];

export const apscvir2026Sessions: ApscvirSessionSeed[] = [
  {
    id: '20262026-0002-4000-8000-000000000001',
    titleEn: 'EVAR and TEVAR 1',
    titleZh: 'EVAR and TEVAR 1',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A101',
    roomZh: 'A1-A101',
    startTime: '2026-06-11T14:00:00+08:00',
    endTime: '2026-06-11T15:30:00+08:00',
    type: 'panel',
    dayIndex: 0,
    sortOrder: 10,
    speakerId: '20262026-0001-4000-8000-000000000005',
    speakerName: 'Robert Morgan / Andrew Holden',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000002',
    titleEn: 'EVAR and TEVAR 2',
    titleZh: 'EVAR and TEVAR 2',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A101',
    roomZh: 'A1-A101',
    startTime: '2026-06-11T15:30:00+08:00',
    endTime: '2026-06-11T17:00:00+08:00',
    type: 'panel',
    dayIndex: 0,
    sortOrder: 20,
    speakerId: '20262026-0001-4000-8000-000000000004',
    speakerName: 'Andrew Holden',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000003',
    titleEn: 'Passing the Torch Mentoring Program',
    titleZh: 'Passing the Torch Mentoring Program',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A110',
    roomZh: 'A1-A110',
    startTime: '2026-06-11T14:00:00+08:00',
    endTime: '2026-06-11T15:30:00+08:00',
    type: 'workshop',
    dayIndex: 0,
    sortOrder: 30,
    speakerId: '20262026-0001-4000-8000-000000000007',
    speakerName: 'Jiaywei Tsauo',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000004',
    titleEn: 'Opening Ceremony',
    titleZh: 'Opening Ceremony',
    descriptionEn: 'Official opening ceremony of APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方开幕式。',
    roomEn: 'A1-A (101-107)',
    roomZh: 'A1-A (101-107)',
    startTime: '2026-06-12T09:30:00+08:00',
    endTime: '2026-06-12T10:00:00+08:00',
    type: 'panel',
    dayIndex: 1,
    sortOrder: 40,
    speakerName: 'APSCVIR 2026 Organizing Committee',
    speakerTitleEn: 'Organizing Committee',
    speakerTitleZh: '组织委员会',
  },
  {
    id: '20262026-0002-4000-8000-000000000005',
    titleEn: 'Keynote Speech',
    titleZh: 'Keynote Speech',
    descriptionEn: 'Official keynote session of APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方主旨演讲环节。',
    roomEn: 'A1-A (101-107)',
    roomZh: 'A1-A (101-107)',
    startTime: '2026-06-12T10:00:00+08:00',
    endTime: '2026-06-12T12:00:00+08:00',
    type: 'keynote',
    dayIndex: 1,
    sortOrder: 50,
    speakerId: '20262026-0001-4000-8000-000000000002',
    speakerName: 'Barry T. Katzen / Robert A. Lookstein / Gao-Jun Teng',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000006',
    titleEn: 'Vascular Anomalies 1',
    titleZh: 'Vascular Anomalies 1',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A101',
    roomZh: 'A1-A101',
    startTime: '2026-06-12T08:00:00+08:00',
    endTime: '2026-06-12T09:00:00+08:00',
    type: 'panel',
    dayIndex: 1,
    sortOrder: 60,
    speakerId: '20262026-0001-4000-8000-000000000006',
    speakerName: 'Ahmad Alomari',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000007',
    titleEn: "Women's Health 1",
    titleZh: "Women's Health 1",
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A102',
    roomZh: 'A1-A102',
    startTime: '2026-06-12T13:00:00+08:00',
    endTime: '2026-06-12T14:30:00+08:00',
    type: 'panel',
    dayIndex: 1,
    sortOrder: 70,
    speakerId: '20262026-0001-4000-8000-000000000009',
    speakerName: 'Anne Roberts / Luke Han Wei Toh',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000008',
    titleEn: 'Interventional Oncology Keynote Speech',
    titleZh: 'Interventional Oncology Keynote Speech',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A (105-107)',
    roomZh: 'A1-A (105-107)',
    startTime: '2026-06-12T16:00:00+08:00',
    endTime: '2026-06-12T18:00:00+08:00',
    type: 'keynote',
    dayIndex: 1,
    sortOrder: 80,
    speakerId: '20262026-0001-4000-8000-000000000011',
    speakerName: 'Riad Salem',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000009',
    titleEn: 'APSCVIR AGM',
    titleZh: 'APSCVIR AGM',
    descriptionEn: 'Official APSCVIR annual general meeting.',
    descriptionZh: 'APSCVIR 官方会员大会。',
    roomEn: 'A1-A101',
    roomZh: 'A1-A101',
    startTime: '2026-06-13T07:00:00+08:00',
    endTime: '2026-06-13T08:00:00+08:00',
    type: 'panel',
    dayIndex: 2,
    sortOrder: 90,
    speakerName: 'APSCVIR',
    speakerTitleEn: 'Annual General Meeting',
    speakerTitleZh: '会员大会',
  },
  {
    id: '20262026-0002-4000-8000-000000000010',
    titleEn: 'TIPS and Portal Vein Intervention 1',
    titleZh: 'TIPS and Portal Vein Intervention 1',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A103',
    roomZh: 'A1-A103',
    startTime: '2026-06-13T08:00:00+08:00',
    endTime: '2026-06-13T09:30:00+08:00',
    type: 'panel',
    dayIndex: 2,
    sortOrder: 100,
    speakerId: '20262026-0001-4000-8000-000000000008',
    speakerName: 'John Kaufman',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000011',
    titleEn: 'Bone, Spine and Soft Tissue Intervention 1',
    titleZh: 'Bone, Spine and Soft Tissue Intervention 1',
    descriptionEn: 'Official program block from APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方日程时段。',
    roomEn: 'A1-A101',
    roomZh: 'A1-A101',
    startTime: '2026-06-14T08:00:00+08:00',
    endTime: '2026-06-14T09:30:00+08:00',
    type: 'panel',
    dayIndex: 3,
    sortOrder: 110,
    speakerName: 'APSCVIR 2026 Faculty',
    speakerTitleEn: 'Faculty',
    speakerTitleZh: '大会嘉宾',
  },
  {
    id: '20262026-0002-4000-8000-000000000012',
    titleEn: 'Closing Ceremony',
    titleZh: 'Closing Ceremony',
    descriptionEn: 'Official closing ceremony of APSCVIR 2026.',
    descriptionZh: 'APSCVIR 2026 官方闭幕式。',
    roomEn: 'A1-A102',
    roomZh: 'A1-A102',
    startTime: '2026-06-14T11:30:00+08:00',
    endTime: '2026-06-14T12:00:00+08:00',
    type: 'panel',
    dayIndex: 3,
    sortOrder: 120,
    speakerName: 'APSCVIR 2026 Organizing Committee',
    speakerTitleEn: 'Organizing Committee',
    speakerTitleZh: '组织委员会',
  },
];

export const apscvir2026Materials: ApscvirMaterialSeed[] = [
  {
    id: '20262026-0003-4000-8000-000000000001',
    nameEn: 'Official APSCVIR 2026 Website',
    nameZh: 'APSCVIR 2026 官方网站',
    fileUrl: APSCVIR_2026_SOURCE_URL,
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000002',
    nameEn: 'About APSCVIR',
    nameZh: '会议简介',
    fileUrl: APSCVIR_2026_ABOUT_URL,
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000003',
    nameEn: 'Detailed Program',
    nameZh: '详细日程',
    fileUrl: APSCVIR_2026_PROGRAM_URL,
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000004',
    nameEn: 'Registration Information',
    nameZh: '注册信息',
    fileUrl: APSCVIR_2026_REGISTRATION_URL,
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000005',
    nameEn: 'Faculty',
    nameZh: '大会嘉宾',
    fileUrl: 'https://www.apscvir2026.com/en/minisite/speaker/29839',
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000006',
    nameEn: 'Organizing Committee',
    nameZh: '组织委员会',
    fileUrl: 'https://www.apscvir2026.com/en/minisite/content/29839?m=1411159',
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000007',
    nameEn: 'Venue',
    nameZh: '会场信息',
    fileUrl: 'https://www.apscvir2026.com/en/minisite/content/29839?m=1520613',
    fileSize: 0,
    type: 'other',
  },
  {
    id: '20262026-0003-4000-8000-000000000008',
    nameEn: 'Contact Us',
    nameZh: '联系方式',
    fileUrl: 'https://www.apscvir2026.com/en/minisite/content/29839?m=1411157',
    fileSize: 0,
    type: 'other',
  },
];
