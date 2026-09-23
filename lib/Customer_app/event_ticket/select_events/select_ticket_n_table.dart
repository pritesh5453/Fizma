import 'package:fizmaa/Customer_app/event_ticket/select_events/payment_selection_screen.dart';
import 'package:flutter/material.dart';

class SelectTicketsScreen extends StatefulWidget {
  const SelectTicketsScreen({Key? key}) : super(key: key);

  @override
  State<SelectTicketsScreen> createState() => _SelectTicketsScreenState();
}

class _SelectTicketsScreenState extends State<SelectTicketsScreen> {
  // Toggle index: 0 -> Show Tickets, 1 -> Tables
  int _selectedExperienceIndex = 0;

  // Ticket quantities
  List<int> ticketQuantities = [0, 0, 0];
  final List<int> ticketPrices = [799, 499, 299];

  // Table quantities
  List<int> tableQuantities = [0, 0];
  final List<int> tablePrices = [10000, 15000];

  int get totalAmount {
    if (_selectedExperienceIndex == 0) {
      int sum = 0;
      for (int i = 0; i < ticketPrices.length; i++) {
        sum += ticketPrices[i] * ticketQuantities[i];
      }
      return sum;
    } else {
      int sum = 0;
      for (int i = 0; i < tablePrices.length; i++) {
        sum += tablePrices[i] * tableQuantities[i];
      }
      return sum;
    }
  }

  int get totalCount {
    if (_selectedExperienceIndex == 0) {
      return ticketQuantities.fold(0, (a, b) => a + b);
    } else {
      return tableQuantities.fold(0, (a, b) => a + b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Select Tickets',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Bhajan Concert',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 4),
                Text(
                  'Sat, 11 Apr - 6:00 PM',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Location Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Siddhivinayak Community Hall, Nashik',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 11,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Saturday, 11 Apr, 2026 • 6:00 PM - 10:30 PM',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Choose your experience title
                  const Text(
                    'Choose your experience',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Select tickets or tables for your bookings.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  // Experience Toggle Buttons
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFFFBBFD8)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedExperienceIndex = 0;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _selectedExperienceIndex == 0
                                    ? Colors.red.shade50
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.confirmation_number_outlined,
                                    size: 20,
                                    color: _selectedExperienceIndex == 0
                                        ? Colors.redAccent
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Show Tickets',
                                    style: TextStyle(
                                      color: _selectedExperienceIndex == 0
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedExperienceIndex = 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _selectedExperienceIndex == 1
                                    ? Colors.red.shade50
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.table_restaurant_outlined,
                                    size: 20,
                                    color: _selectedExperienceIndex == 1
                                        ? Colors.redAccent
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Tables',
                                    style: TextStyle(
                                      color: _selectedExperienceIndex == 1
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title (Dynamic based on selected tab)
                  Text(
                    _selectedExperienceIndex == 0
                        ? 'Choose your ticket'
                        : 'Choose your table',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedExperienceIndex == 0
                        ? 'Discover the best experience for you'
                        : 'All prices are for the full table',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Content View (Tickets vs Tables)
                  _selectedExperienceIndex == 0
                      ? _buildTicketsList()
                      : _buildTablesList(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Bar Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50.withOpacity(0.2),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹$totalAmount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      '$totalCount ${_selectedExperienceIndex == 0 ? 'tickets' : 'Table'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 44,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      // 🔥 Book Now => Gender popup open
                      showSelectGenderSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // List Widget for Tickets
  Widget _buildTicketsList() {
    return Column(
      children: [
        _buildTicketCard(
          index: 0,
          title: 'VIP Pass',
          emoji: '👑',
          price: 799,
          isBestValue: true,
        ),
        const SizedBox(height: 12),
        _buildTicketCard(
          index: 1,
          title: 'Premium Pass',
          emoji: '💎',
          price: 499,
          isBestValue: false,
        ),
        const SizedBox(height: 12),
        _buildTicketCard(
          index: 2,
          title: 'General Pass',
          emoji: '🏷️',
          price: 299,
          isBestValue: false,
        ),
      ],
    );
  }

  Widget _buildTicketCard({
    required int index,
    required String title,
    required String emoji,
    required int price,
    required bool isBestValue,
  }) {
    final qty = ticketQuantities[index];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: qty > 0
                ? Colors.green.shade50.withOpacity(0.3)
                : Colors.white,
            border: Border.all(
              color: qty > 0
                  ? Colors.green.shade200
                  : (isBestValue
                      ? Colors.green.shade200
                      : Colors.grey.shade200),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹$price',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Onward',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              _buildCounterWidget(
                count: qty,
                onDecrement: () {
                  if (qty > 0) {
                    setState(() {
                      ticketQuantities[index]--;
                    });
                  }
                },
                onIncrement: () {
                  setState(() {
                    ticketQuantities[index]++;
                  });
                },
              ),
            ],
          ),
        ),
        if (isBestValue)
          Positioned(
            right: 12,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_border, size: 10, color: Colors.redAccent),
                  SizedBox(width: 2),
                  Text(
                    'BEST VALUE',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // List Widget for Tables
  Widget _buildTablesList() {
    return Column(
      children: [
        _buildTableCard(
          index: 0,
          tableNo: 'TABLE 1',
          tableCode: 'T4',
          title: 'VIP Table',
          emoji: '👑',
          price: 10000,
          maxCapacity: 4,
          isBestValue: true,
        ),
        const SizedBox(height: 12),
        _buildTableCard(
          index: 1,
          tableNo: 'TABLE 2',
          tableCode: 'T6',
          title: 'Premium Table',
          emoji: '👑',
          price: 15000,
          maxCapacity: 6,
          isBestValue: false,
        ),
      ],
    );
  }

  Widget _buildTableCard({
    required int index,
    required String tableNo,
    required String tableCode,
    required String title,
    required String emoji,
    required int price,
    required int maxCapacity,
    required bool isBestValue,
  }) {
    final qty = tableQuantities[index];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: qty > 0
                ? Colors.green.shade50.withOpacity(0.3)
                : Colors.white,
            border: Border.all(
              color: qty > 0
                  ? Colors.green.shade200
                  : (isBestValue
                      ? Colors.green.shade200
                      : Colors.grey.shade200),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tableNo,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tableCode,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '/ Full table',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Max Capacity $maxCapacity members',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Add extra members if needed',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildCounterWidget(
                        count: qty,
                        onDecrement: () {
                          if (qty > 0) {
                            setState(() {
                              tableQuantities[index]--;
                            });
                          }
                        },
                        onIncrement: () {
                          setState(() {
                            tableQuantities[index]++;
                          });
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Available seats: $maxCapacity',
                        style: const TextStyle(fontSize: 9, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isBestValue)
          Positioned(
            right: 12,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_border, size: 10, color: Colors.redAccent),
                  SizedBox(width: 2),
                  Text(
                    'BEST VALUE',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Reusable Incremental/Decremental Counter Widget
  Widget _buildCounterWidget({
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.remove, size: 16, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.add, size: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


// Popup Show karne ke liye function
void showSelectGenderSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SelectGenderWidget(),
  );
}

class SelectGenderWidget extends StatefulWidget {
  const SelectGenderWidget({Key? key}) : super(key: key);

  @override
  State<SelectGenderWidget> createState() => _SelectGenderWidgetState();
}

class _SelectGenderWidgetState extends State<SelectGenderWidget> {
  int femaleCount = 1;
  int maleCount = 0;
  final int ticketPrice = 799;

  int get totalTickets => femaleCount + maleCount;
  int get totalAmount => totalTickets * ticketPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey.shade100,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'This selection is for VIP Pass ($totalTickets Ticket${totalTickets > 1 ? 's' : ''})',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Cards Row (Female & Male selection)
          Row(
            children: [
              // Female Selection Card
              Expanded(
                child: _buildGenderCard(
                  title: 'Female',
                  avatarBgColor: Colors.pink.shade50,
                  avatarIcon: Icons.face_3,
                  iconColor: Colors.pinkAccent,
                  count: femaleCount,
                  isSelected: femaleCount > 0,
                  onIncrement: () {
                    setState(() {
                      femaleCount++;
                    });
                  },
                  onDecrement: () {
                    if (femaleCount > 0) {
                      setState(() {
                        femaleCount--;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Male Selection Card
              Expanded(
                child: _buildGenderCard(
                  title: 'Male',
                  avatarBgColor: Colors.blue.shade50,
                  avatarIcon: Icons.person_outline,
                  iconColor: Colors.blue,
                  count: maleCount,
                  isSelected: maleCount > 0,
                  onIncrement: () {
                    setState(() {
                      maleCount++;
                    });
                  },
                  onDecrement: () {
                    if (maleCount > 0) {
                      setState(() {
                        maleCount--;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Female Count Pill
                        _buildGenderSummaryChip(
                          icon: Icons.face_3,
                          iconColor: Colors.pinkAccent,
                          bgColor: Colors.pink.shade50,
                          label: 'Female',
                          count: femaleCount,
                        ),
                        const SizedBox(width: 12),
                        // Male Count Pill
                        _buildGenderSummaryChip(
                          icon: Icons.person_outline,
                          iconColor: Colors.blue,
                          bgColor: Colors.blue.shade50,
                          label: 'Male',
                          count: maleCount,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '$totalTickets Ticket${totalTickets > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 16,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹$totalAmount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subtext
          const Center(
            child: Text(
              'Your information is safe and secure',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          // Done Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const ReviewBookingScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Selection Card (Female/Male)
  Widget _buildGenderCard({
    required String title,
    required Color avatarBgColor,
    required IconData avatarIcon,
    required Color iconColor,
    required int count,
    required bool isSelected,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isSelected ? Colors.green.shade400 : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: avatarBgColor,
                    child: Icon(avatarIcon, size: 16, color: iconColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Counter Controls
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.black54,
                      ),
                      onPressed: onDecrement,
                    ),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black54,
                      ),
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }

  // Helper Widget: Summary Chips
  Widget _buildGenderSummaryChip({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required int count,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: bgColor,
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        CircleAvatar(
          radius: 9,
          backgroundColor: Colors.black,
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}