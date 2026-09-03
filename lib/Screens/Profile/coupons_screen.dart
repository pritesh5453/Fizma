import 'package:fizmaa/Screens/Profile/create_coupons_screen.dart';
import 'package:flutter/material.dart';

class CouponsMainScreen extends StatefulWidget {
  const CouponsMainScreen({Key? key}) : super(key: key);

  @override
  State<CouponsMainScreen> createState() => _CouponsMainScreenState();
}

class _CouponsMainScreenState extends State<CouponsMainScreen> {
  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'EARLYBIRD25',
      'subtitle': 'Web Summit 2025',
      'discount': '25% OFF',
      'status': 'Active',
      'statusColor': Colors.green.shade100,
      'statusTextColor': Colors.green.shade800,
      'used': 312,
      'total': 500,
      'perUser': '1x',
      'expires': '2025-08-31',
    },
    {
      'code': 'JAZZNIGHT10',
      'subtitle': 'Jazz Under the Stars',
      'discount': '₹10 OFF',
      'status': 'Active',
      'statusColor': Colors.green.shade100,
      'statusTextColor': Colors.green.shade800,
      'used': 67,
      'total': 100,
      'perUser': '1x',
      'expires': '2025-08-22',
    },
    {
      'code': 'FOUNDER50',
      'subtitle': 'Founders Dinner — Austin',
      'discount': '₹50 OFF',
      'status': 'Expired',
      'statusColor': Colors.grey.shade200,
      'statusTextColor': Colors.grey.shade700,
      'used': 20,
      'total': 20,
      'perUser': '1x',
      'expires': '2025-09-04',
    },
    {
      'code': 'VIP2025',
      'subtitle': 'All Events',
      'discount': '15% OFF',
      'status': 'Active',
      'statusColor': Colors.green.shade100,
      'statusTextColor': Colors.green.shade800,
      'used': 8,
      'total': 50,
      'perUser': '1x',
      'expires': '2025-09-30',
    },
    {
      'code': 'AIWORKSHOP',
      'subtitle': 'AI Workshop Series',
      'discount': '₹30 OFF',
      'status': 'Scheduled',
      'statusColor': Colors.lightBlue.shade100,
      'statusTextColor': Colors.lightBlue.shade800,
      'used': 0,
      'total': 200,
      'perUser': '2x',
      'expires': '2025-10-04',
    },
  ];

  void _showCreateCouponBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateCouponBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F8),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coupons', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Manage all coupons', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              onPressed: () => _showCreateCouponBottomSheet(context),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: _coupons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _coupons[index];
              final double progress = item['total'] > 0 ? item['used'] / item['total'] : 0.0;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_offer_outlined, color: Color(0xFFFF3B30), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['code'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(item['subtitle'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item['discount'],
                              style: const TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item['statusColor'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['status'],
                                style: TextStyle(color: item['statusTextColor'], fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Used: ',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            children: [
                              TextSpan(
                                text: '${item['used']}/${item['total']}',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Per user: ',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            children: [
                              TextSpan(
                                text: '${item['perUser']}',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Expires: ',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            children: [
                              TextSpan(
                                text: '${item['expires']}',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.red.shade50,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF3B30)),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Save & Review Details', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

