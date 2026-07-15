import 'package:flutter/material.dart';

class AboutTab extends StatefulWidget {
  const AboutTab({super.key});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool isTermsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. About the Event Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withOpacity(0.15), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'About the Event',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Celebrate the divine essence of Ram Navami with an enchanting evening of soul-stirring Bhajans. Join us in the spiritual heart of Nashik for a musical journey that transcends...',
                style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'Read more',
                      style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.redAccent, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. The Experience Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEF), // Warm background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.shade100, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber[700], size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'The Experience',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber[900]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag(Icons.bolt, 'Divine Energy'),
                  _buildTag(Icons.music_note, 'Live Bhajans'),
                  _buildTag(Icons.brightness_high_outlined, 'Spiritual Connection'),
                  _buildTag(Icons.spa_outlined, 'Peaceful Ambience'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Our Sponsors Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_outline_rounded, color: Colors.amber[700], size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'Our Sponsors',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'K',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'K for Kathiyawad',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Official Food Sponsor',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 4. Terms & Conditions Card (With Accordion/Expand logic)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTermsExpanded = !isTermsExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assignment_outlined, color: Colors.grey[700], size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          'Terms & Conditions',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    Icon(
                      isTermsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              if (isTermsExpanded) ...[
                const SizedBox(height: 12),
                _buildTermBullet('Entry is subject to valid ID proof.'),
                _buildTermBullet('No refunds after booking confirmation.'),
                _buildTermBullet('Outside food and beverages not allowed.'),
                _buildTermBullet('Event schedule subject to change.'),
                _buildTermBullet('Photography allowed for personal use only.'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Sub component for small pills inside experience
  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.orange[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.orange[800], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Bullet Point Builder
  Widget _buildTermBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}