import 'package:fizma/Screens/add_event/create_ticket/PreviewTicketScreen.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class CreateTicketDetailsScreen extends StatefulWidget {
  const CreateTicketDetailsScreen({super.key});

  @override
  State<CreateTicketDetailsScreen> createState() => _CreateTicketDetailsScreenState();
}

class _CreateTicketDetailsScreenState extends State<CreateTicketDetailsScreen> {
  final TextEditingController ticketNameController = TextEditingController(text: 'VIP PASS');
  final TextEditingController totalTicketsController = TextEditingController(text: '1');
  final TextEditingController ticketPriceController = TextEditingController(text: '500');
  final TextEditingController maxPersonsController = TextEditingController(text: '1');
  final TextEditingController eventCapacityController = TextEditingController(text: '500');
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController belowThresholdController = TextEditingController(text: '10');
  final TextEditingController increaseByController = TextEditingController(text: '5');
  final TextEditingController advancePercentController = TextEditingController(text: '50');
  final TextEditingController eventStartController = TextEditingController(text: '29 Jan 2025');
  final TextEditingController eventEndController = TextEditingController(text: '30 Jan 2025');
  final TextEditingController minTicketsController = TextEditingController(text: '1');
  final TextEditingController maxTicketsController = TextEditingController(text: '200');

  bool maxPersonsToggle = false;
  bool dynamicPricing = true;
  bool advancePayment = true;
  bool ticketActive = true;

  int maleCount = 0;
  int femaleCount = 0;
  int otherCount = 0;

  final List<Map<String, TextEditingController>> addOns = [
    {
      'title': TextEditingController(),
      'price': TextEditingController(),
    },
  ];

  @override
  void dispose() {
    ticketNameController.dispose();
    totalTicketsController.dispose();
    ticketPriceController.dispose();
    maxPersonsController.dispose();
    eventCapacityController.dispose();
    descriptionController.dispose();
    belowThresholdController.dispose();
    increaseByController.dispose();
    advancePercentController.dispose();
    eventStartController.dispose();
    eventEndController.dispose();
    minTicketsController.dispose();
    maxTicketsController.dispose();
    for (final a in addOns) {
      a['title']!.dispose();
      a['price']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(Icons.confirmation_number_outlined, 'Ticket Details'),
                      const SizedBox(height: 14),

                      _label('Ticket Name'),
                      const SizedBox(height: 8),
                      _textField(
                        controller: ticketNameController,
                        trailingIcon: Icons.delete_outline,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Total Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: totalTicketsController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Ticket Price'),
                                const SizedBox(height: 8),
                                _textField(controller: ticketPriceController, prefixText: '₹ '),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.kRed),
                          SizedBox(width: 6),
                          Text(
                            'Maximum free ticket limit exceeded',
                            style: TextStyle(fontSize: 11.5, color: AppColors.kRed),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      _toggleRow(
                        icon: Icons.person_outline,
                        label: 'Max Persons per Ticket',
                        value: maxPersonsToggle,
                        onChanged: (v) => setState(() => maxPersonsToggle = v),
                      ),
                      const SizedBox(height: 8),
                      _textField(controller: maxPersonsController),
                      const SizedBox(height: 18),

                      Row(
                        children: const [
                          Icon(Icons.person_outline, size: 16, color: AppColors.kTextDark),
                          SizedBox(width: 6),
                          Text(
                            'Event Capacity',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _textField(controller: eventCapacityController),
                      const SizedBox(height: 18),

                      _label('Age Restriction'),
                      const SizedBox(height: 8),
                      _dropdownField('All Ages'),
                      const SizedBox(height: 18),

                      Center(child: _label('Gender Allocation(optional)')),
                      const SizedBox(height: 10),
                      _genderAllocationCard(),
                      const SizedBox(height: 18),

                      _label('Description'),
                      const SizedBox(height: 8),
                      _descriptionBox(),
                      const SizedBox(height: 20),

                      _toggleRow(
                        label: 'Dynamic Pricing',
                        value: dynamicPricing,
                        bold: true,
                        onChanged: (v) => setState(() => dynamicPricing = v),
                        subtitle: 'Automatically increase ticket price when availability becomes low.',
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('When tickets left below'),
                                const SizedBox(height: 8),
                                _textField(controller: belowThresholdController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Increase by'),
                                const SizedBox(height: 8),
                                _textField(controller: increaseByController, suffixText: '%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _dynamicPricingSummaryCard(),
                      const SizedBox(height: 20),

                      _toggleRow(
                        label: 'Advance Payment',
                        value: advancePayment,
                        bold: true,
                        onChanged: (v) => setState(() => advancePayment = v),
                        subtitle: 'Add your advance payment for confirming booking',
                      ),
                      const SizedBox(height: 14),
                      _label('Advance Percentage'),
                      const SizedBox(height: 8),
                      _textField(controller: advancePercentController, suffixText: '%'),
                      const SizedBox(height: 22),

                      _sectionHeader(Icons.event_available_outlined, 'Availability', muted: true),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Event Start'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: eventStartController,
                                  trailingIcon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Event End'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: eventEndController,
                                  trailingIcon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Min Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: minTicketsController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Max Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: maxTicketsController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _addOnCard(),
                      const SizedBox(height: 18),
                      const Divider(color: AppColors.kBorder, height: 1),
                      const SizedBox(height: 16),

                      _toggleRow(
                        label: 'Ticket Active',
                        value: ticketActive,
                        bold: true,
                        onChanged: (v) => setState(() => ticketActive = v),
                        subtitle: 'Visible to users for purchase',
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Top App Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Tickets',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDark,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'For Wed, 29 Jan 2025 | 03:58PM',
                      style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.45)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 4),
            child: Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.kTextDark.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  // ---------- Section header with leading icon ----------
  Widget _sectionHeader(IconData icon, String text, {bool muted = false}) {
    final color = muted ? AppColors.kTextDark.withOpacity(0.55) : AppColors.kRed;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: muted ? AppColors.kTextDark.withOpacity(0.7) : AppColors.kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.kTextDark,
      ),
    );
  }

  // ---------- Generic text field ----------
  Widget _textField({
    required TextEditingController controller,
    String? prefixText,
    String? suffixText,
    IconData? trailingIcon,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (prefixText != null)
            Text(prefixText, style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
            ),
          ),
          if (suffixText != null)
            Text(suffixText, style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          if (trailingIcon != null) ...[
            const SizedBox(width: 6),
            Icon(trailingIcon, size: 17, color: AppColors.kRed),
          ],
        ],
      ),
    );
  }

  // ---------- Dropdown-style field ----------
  Widget _dropdownField(String value) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
        ],
      ),
    );
  }

  // ---------- Toggle row (label [+subtitle] + switch) ----------
  Widget _toggleRow({
    IconData? icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    bool bold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.kTextDark),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: bold ? 14.5 : 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.kRed,
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.5)),
          ),
        ],
      ],
    );
  }

  // ---------- Gender allocation bordered card ----------
  Widget _genderAllocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        children: [
          _genderRow(
            icon: Icons.male,
            iconBg: const Color(0xFF4472D8),
            label: 'Male',
            count: maleCount,
            onDecrement: () => setState(() => maleCount = (maleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => maleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.female,
            iconBg: AppColors.primaryRedDark,
            label: 'Female',
            count: femaleCount,
            onDecrement: () => setState(() => femaleCount = (femaleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => femaleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.transgender,
            iconBg: const Color(0xFF3E8E5B),
            label: 'Other',
            count: otherCount,
            onDecrement: () => setState(() => otherCount = (otherCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => otherCount++),
          ),
        ],
      ),
    );
  }

  Widget _genderRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: AppColors.kWhite),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
            ),
          ),
          _counterButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
            ),
          ),
          _counterButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }

  Widget _counterButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kBorder, width: 1.2),
        ),
        child: Icon(icon, size: 14, color: AppColors.kTextDark.withOpacity(0.6)),
      ),
    );
  }

  // ---------- Description textarea ----------
  Widget _descriptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: "What's included in this ticket...",
          hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
        ),
        style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
      ),
    );
  }

  // ---------- Dynamic pricing summary card (Current -> Triggered) ----------
  Widget _dynamicPricingSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Price:', style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Text(
                  '₹ ${ticketPriceController.text.isEmpty ? '0' : ticketPriceController.text}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.kRed),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.kRed, size: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Triggered Price:', style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '₹ 525',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.kRed),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.kRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Auto Applied',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Add-on section card ----------
  Widget _addOnCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add-on',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: Text('Title', style: TextStyle(fontSize: 12, color: AppColors.kHint)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text('Price (₹)', style: TextStyle(fontSize: 12, color: AppColors.kHint)),
              ),
              SizedBox(width: 38),
            ],
          ),
          const SizedBox(height: 8),
          ...addOns.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _textField(controller: a['title']!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(controller: a['price']!),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        if (addOns.length > 1) {
                          setState(() => addOns.remove(a));
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.delete_outline, color: AppColors.kRed, size: 20),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  addOns.add({
                    'title': TextEditingController(),
                    'price': TextEditingController(),
                  });
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.kWhite,
                side: const BorderSide(color: AppColors.kRed, width: 1.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, size: 16, color: AppColors.kRed),
              label: const Text(
                'Add More',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.kRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Bottom Back / Submit Buttons ----------
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kRed),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewTicketScreen(
                        ticketName: ticketNameController.text.isEmpty
                            ? 'TechTalk 2025'
                            : ticketNameController.text,
                        seats: int.tryParse(eventCapacityController.text) ?? 100,
                        totalPrice: double.tryParse(ticketPriceController.text) ?? 499,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}