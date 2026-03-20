import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventAgendaScreen extends StatefulWidget {
  const EventAgendaScreen({super.key});

  @override
  State<EventAgendaScreen> createState() => _EventAgendaScreenState();
}

class _EventAgendaScreenState extends State<EventAgendaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color surfaceColor = Color(0xFFDBF1FE);
    const Color accentColor = Color(0xFFFFDEA5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Event Details',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'AGENDA'),
            Tab(text: 'SPEAKERS'),
            Tab(text: 'MATERIALS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Agenda Tab
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 4,
            itemBuilder: (context, index) {
              final isZh = Get.locale?.languageCode == 'zh';
              final sessionData = [
                {
                  'type': 'KEYNOTE',
                  'time': '09:00 - 10:00',
                  'titleEn': 'Future of AI in Genomic Research',
                  'titleZh': '人工智能在基因组研究中的未来展望',
                  'room': isZh ? '第一学术报告厅' : 'Lecture Hall 1',
                  'speaker': 'Dr. Sarah Chen, PhD',
                  'speakerTitle': isZh ? '斯坦福医学院生物信息学主任' : 'Director of Bio-Informatics, Stanford Medicine',
                  'avatar': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop'
                },
                {
                  'type': 'RESEARCH PAPER',
                  'time': '10:15 - 11:15',
                  'titleEn': 'Breakthroughs in CAR-T Cell Therapy',
                  'titleZh': 'CAR-T细胞疗法的重大突破',
                  'room': isZh ? '研讨会第二厅' : 'Seminar Hall 2',
                  'speaker': 'Prof. James Sterling',
                  'speakerTitle': isZh ? '梅奥诊所肿瘤学负责人' : 'Oncology Lead, Mayo Clinic',
                  'avatar': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop'
                },
                {
                  'type': 'WORKSHOP',
                  'time': '13:00 - 14:30',
                  'titleEn': 'Precision Medicine: From Data to Dosage',
                  'titleZh': '精准医学：从数据到剂量',
                  'room': isZh ? '创新实验室 4' : 'Innovation Lab 4',
                  'speaker': 'Dr. Elena Rodriguez',
                  'speakerTitle': isZh ? '诺华高级药理学家' : 'Senior Pharmacologist, Novartis',
                  'avatar': 'https://images.unsplash.com/photo-1594824461559-67d483b3e32e?q=80&w=200&auto=format&fit=crop'
                },
                {
                  'type': 'PANEL',
                  'time': '15:00 - 16:30',
                  'titleEn': 'Ethical Frameworks for Global Health Data',
                  'titleZh': '全球健康数据的伦理框架',
                  'room': isZh ? '数字套房 A' : 'Digital Suite A',
                  'speaker': 'Panel: WHO Ethics Committee',
                  'speakerTitle': isZh ? '多讲者联合论坛' : 'Multi-speaker Session',
                  'avatar': 'https://images.unsplash.com/photo-1537368910025-7028a1ab9b98?q=80&w=200&auto=format&fit=crop'
                },
              ];
              final data = sessionData[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: index == 0 ? accentColor : primaryColor, width: 4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: index == 0 ? accentColor : surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['type']!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: index == 0 ? primaryColor : primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          data['time']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isZh ? data['titleZh']! : data['titleEn']!,
                      style: TextStyle(
                        fontFamily: 'Noto Serif',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isZh ? data['titleEn']! : data['titleZh']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          data['room']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                            image: DecorationImage(
                              image: NetworkImage(data['avatar']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['speaker']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                data['speakerTitle']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Speakers Tab
          const Center(child: Text('Speakers List')),
          // Materials Tab
          const Center(child: Text('Materials List')),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add to My Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
