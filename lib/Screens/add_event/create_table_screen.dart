import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

// ---------- Table Data Model ----------
class TableTier {
  final String id;
  final String name;
  final int totalTables;
  final double price;
  final int maxPerPerson;
  bool isActive;   // 👈 final hata diya
  final bool reservationEnabled;
  final bool isDynamicPricing;

  TableTier({
    required this.id,
    required this.name,
    required this.totalTables,
    required this.price,
    required this.maxPerPerson,
    this.isActive = true,
    this.reservationEnabled = false,
    this.isDynamicPricing = false,
  });
}

// ---------- Function to show Table Bottom Sheet ----------
Future<TableTier?> showCreateTableBottomSheet(
  BuildContext context,
  int capacity,
) {
  return showModalBottomSheet<TableTier>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CreateTableBottomSheet(capacity: capacity, eventId: 1,),  // event ID Dummy
  );
}

// ---------- Bottom Sheet Widget ----------
class CreateTableBottomSheet extends StatefulWidget {
  final int capacity;
  const CreateTableBottomSheet({super.key, required this.capacity, required int eventId});

  @override
  State<CreateTableBottomSheet> createState() => _CreateTableBottomSheetState();
}

class _CreateTableBottomSheetState extends State<CreateTableBottomSheet> {
  final TextEditingController tableNameController =
      TextEditingController(text: 'VIP Table');
  final TextEditingController totalTableController =
      TextEditingController(text: '1');
  final TextEditingController tablePriceController =
      TextEditingController(text: '500');
  final TextEditingController maxPersonsController =
      TextEditingController(text: '4');
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController belowThresholdController =
      TextEditingController(text: '10');
  final TextEditingController increaseByController =
      TextEditingController(text: '5');
  final TextEditingController advancePercentController =
      TextEditingController(text: '50');
  final TextEditingController minTableController =
      TextEditingController(text: '1');
  final TextEditingController maxTableController =
      TextEditingController(text: '200');
  final TextEditingController extraGuestsController = TextEditingController();
  final TextEditingController maxGuestController = TextEditingController();
  final TextEditingController pricePerMaleController = TextEditingController();
  final TextEditingController pricePerFemaleController =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  bool tableNameToggle = true;
  bool dynamicPricing = true;
  bool advancePayment = true;
  bool extraPersonAddOn = true;
  bool priceGenderWise = true;
  bool oneTimeCheckIn = true;
  bool tableActive = true;
  bool reservationEnabled = false;

  int maleCount = 0;
  int femaleCount = 0;
  int otherCount = 0;

  int genderPriceMaleCount = 0;
  int genderPriceFemaleCount = 0;

  final List<Map<String, TextEditingController>> addOns = [
    {'title': TextEditingController(), 'price': TextEditingController()},
  ];

  String _selectedAgeRestriction = 'All Ages';
  final List<String> _ageOptions = ['All Ages', '5+', '18+', '21+'];

  static const int _descriptionMaxLength = 300;
  int _descriptionLength = 0;

  @override
  void initState() {
    super.initState();
    descriptionController.addListener(_updateDescriptionLength);
    _updateDescriptionLength();
  }

  void _updateDescriptionLength() {
    setState(() {
      _descriptionLength = descriptionController.text.length;
    });
  }

  @override
  void dispose() {
    tableNameController.dispose();
    totalTableController.dispose();
    tablePriceController.dispose();
    maxPersonsController.dispose();
    descriptionController.dispose();
    belowThresholdController.dispose();
    increaseByController.dispose();
    advancePercentController.dispose();
    minTableController.dispose();
    maxTableController.dispose();
    extraGuestsController.dispose();
    maxGuestController.dispose();
    pricePerMaleController.dispose();
    pricePerFemaleController.dispose();
    contactNumberController.dispose();
    for (final a in addOns) {
      a['title']!.dispose();
      a['price']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: AppColors.screenGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Table Name',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kTextDark),
                            ),
                          ),
                          Switch(
                            value: tableNameToggle,
                            onChanged: (v) => setState(() => tableNameToggle = v),
                            activeColor: AppColors.kRed,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _textField(controller: tableNameController),
                      const SizedBox(height: 16),

                      _toggleRow(
                        label: 'Reservation',
                        value: reservationEnabled,
                        bold: true,
                        onChanged: (v) => setState(() => reservationEnabled = v),
                        subtitle:
                            'Replace online pricing and checkout with a \nphone call button for this table.',
                      ),
                      if (reservationEnabled) ...[
                        const SizedBox(height: 10),
                        _label('Contact Number'),
                        const SizedBox(height: 8),
                        _textField(
                          controller: contactNumberController,
                          hint: 'Enter contact number',
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                      const SizedBox(height: 8),

                      const SizedBox(height: 18),
                      _label('Description'),
                      const SizedBox(height: 8),
                      _descriptionBox(),
                      const SizedBox(height: 20),

                      if (!reservationEnabled) ...[
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Total Table'),
                                  const SizedBox(height: 8),
                                  _textField(controller: totalTableController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Table Price'),
                                  const SizedBox(height: 8),
                                  _textField(
                                      controller: tablePriceController,
                                      prefixText: '₹ '),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        Row(
                          children: const [
                            Icon(Icons.person_outline,
                                size: 16, color: AppColors.kTextDark),
                            SizedBox(width: 6),
                            Text(
                              'Max Persons per Table',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kTextDark),
                            ),
                          ],
                        ),
                        _textField(controller: maxPersonsController),
                        const SizedBox(height: 18),

                        _label('Age Restriction'),
                        const SizedBox(height: 8),
                        _ageRestrictionDropdown(),
                        const SizedBox(height: 18),

                        _label('Gender Allocation(optional)'),
                        const SizedBox(height: 10),
                        _genderAllocationCard(),
                        const SizedBox(height: 18),

                        _sectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _toggleRow(
                                label: 'Dynamic Pricing',
                                value: dynamicPricing,
                                bold: true,
                                onChanged: (v) =>
                                    setState(() => dynamicPricing = v),
                                subtitle:
                                    'Automatically increase Table price when availability becomes low.',
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('When Tables left below'),
                                        const SizedBox(height: 8),
                                        _textField(
                                            controller: belowThresholdController),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Increase by'),
                                        const SizedBox(height: 8),
                                        _textField(
                                            controller: increaseByController,
                                            suffixText: '%'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _dynamicPricingSummaryCard(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _toggleRow(
                          label: 'Advance Payment',
                          value: advancePayment,
                          bold: true,
                          onChanged: (v) => setState(() => advancePayment = v),
                          subtitle:
                              'Add your advance payment for confirming booking',
                        ),
                        const SizedBox(height: 14),
                        _label('Advance Percentage'),
                        const SizedBox(height: 8),
                        _textField(
                            controller: advancePercentController,
                            suffixText: '%'),
                        const SizedBox(height: 22),

                        _sectionHeader(Icons.event_available_outlined,
                            'Availability',
                            muted: true),
                        const SizedBox(height: 14),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Min Table'),
                                  const SizedBox(height: 8),
                                  _textField(controller: minTableController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Max Table'),
                                  const SizedBox(height: 8),
                                  _textField(controller: maxTableController),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _toggleRow(
                          label: 'Extra Person Add-on',
                          value: extraPersonAddOn,
                          bold: true,
                          onChanged: (v) =>
                              setState(() => extraPersonAddOn = v),
                          subtitle:
                              'Define the charge applicable for each extra guest.',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Max Number of Extra Guests',
                                    style: TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.kTextDark
                                            .withOpacity(0.55)),
                                  ),
                                  const SizedBox(height: 8),
                                  _textField(
                                      controller: extraGuestsController,
                                      hint: 'Title'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price Per Extra Guest',
                                    style: TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.kTextDark
                                            .withOpacity(0.55)),
                                  ),
                                  const SizedBox(height: 8),
                                  _textField(
                                      controller: maxGuestController,
                                      hint: 'Value'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _toggleRow(
                          label: 'Set Price Gender Wise',
                          value: priceGenderWise,
                          bold: true,
                          onChanged: (v) =>
                              setState(() => priceGenderWise = v),
                        ),

                        if (priceGenderWise) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _genderMiniCard(
                                  icon: Icons.person,
                                  label: 'Male',
                                  count: genderPriceMaleCount,
                                  onDecrement: () => setState(() =>
                                      genderPriceMaleCount =
                                          (genderPriceMaleCount - 1).clamp(0, 999)),
                                  onIncrement: () =>
                                      setState(() => genderPriceMaleCount++),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _genderMiniCard(
                                  icon: Icons.person,
                                  label: 'Female',
                                  count: genderPriceFemaleCount,
                                  onDecrement: () => setState(() =>
                                      genderPriceFemaleCount =
                                          (genderPriceFemaleCount - 1).clamp(0, 999)),
                                  onIncrement: () =>
                                      setState(() => genderPriceFemaleCount++),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price Per Male Guest',
                                      style: TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.kTextDark
                                              .withOpacity(0.55)),
                                    ),
                                    const SizedBox(height: 8),
                                    _textField(
                                        controller: pricePerMaleController,
                                        hint: 'Value'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price Per Female Guest',
                                      style: TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.kTextDark
                                              .withOpacity(0.55)),
                                    ),
                                    const SizedBox(height: 8),
                                    _textField(
                                        controller: pricePerFemaleController,
                                        hint: 'Value'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ] else ...[
                          const SizedBox(height: 20),
                        ],

                        _toggleRow(
                          label: 'One Time Check In Only',
                          value: oneTimeCheckIn,
                          bold: true,
                          onChanged: (v) =>
                              setState(() => oneTimeCheckIn = v),
                        ),
                        const SizedBox(height: 20),

                        _addOnCard(),
                        const SizedBox(height: 18),
                        const Divider(color: AppColors.kBorder, height: 1),
                        const SizedBox(height: 16),

                        _toggleRow(
                          label: 'Table Active',
                          value: tableActive,
                          bold: true,
                          onChanged: (v) => setState(() => tableActive = v),
                          subtitle: 'Visible to users for purchase',
                        ),
                      ],
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

  // ---------- Top Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              'Create Table',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                Text(
                  'For Wed, 29 Jan 2025 | 03:58PM',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.kTextDark.withOpacity(0.45),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: child,
    );
  }

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
            color: muted
                ? AppColors.kTextDark.withOpacity(0.7)
                : AppColors.kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String? prefixText,
    String? suffixText,
    String? hint,
    TextInputType? keyboardType,
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
            Text(prefixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
            ),
          ),
          if (suffixText != null)
            Text(suffixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
        ],
      ),
    );
  }

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
                  fontWeight: FontWeight.w700,
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
            style: TextStyle(
                fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.5)),
          ),
        ],
      ],
    );
  }

  Widget _ageRestrictionDropdown() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAgeRestriction,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.kHint),
          items: _ageOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.kTextDark)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedAgeRestriction = newValue!;
            });
          },
        ),
      ),
    );
  }

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
            onDecrement: () =>
                setState(() => maleCount = (maleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => maleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.female,
            iconBg: AppColors.primaryRedDark,
            label: 'Female',
            count: femaleCount,
            onDecrement: () =>
                setState(() => femaleCount = (femaleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => femaleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.transgender,
            iconBg: const Color(0xFF3E8E5B),
            label: 'Other',
            count: otherCount,
            onDecrement: () =>
                setState(() => otherCount = (otherCount - 1).clamp(0, 999)),
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
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark),
            ),
          ),
          _counterButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark),
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

  Widget _genderMiniCard({
    required IconData icon,
    required String label,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                    color: AppColors.kRed, shape: BoxShape.circle),
                child: Icon(icon, size: 12, color: AppColors.kWhite),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _counterButtonSmall(icon: Icons.remove, onTap: onDecrement),
              Text(
                '$count',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDark),
              ),
              _counterButtonSmall(icon: Icons.add, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterButtonSmall({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kBorder, width: 1.2),
        ),
        child: Icon(icon, size: 12, color: AppColors.kTextDark.withOpacity(0.6)),
      ),
    );
  }

  Widget _descriptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: descriptionController,
            maxLines: 3,
            maxLength: _descriptionMaxLength,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: "What's included in this table...",
              hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$_descriptionLength / $_descriptionMaxLength',
              style: TextStyle(
                fontSize: 12,
                color: _descriptionLength > _descriptionMaxLength
                    ? AppColors.kRed
                    : AppColors.kHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                Text('Current Price:',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Text(
                  '₹ ${tablePriceController.text.isEmpty ? '0' : tablePriceController.text}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.kRed),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.kRed, size: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Triggered Price:',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '₹ 525',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.kRed),
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
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kWhite),
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
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: Text('Title',
                    style: TextStyle(fontSize: 12, color: AppColors.kHint)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text('Price (₹)',
                    style: TextStyle(fontSize: 12, color: AppColors.kHint)),
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
                      child: _textField(controller: a['title']!, hint: 'Title'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(controller: a['price']!, hint: 'Value'),
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
                        child: Icon(Icons.delete_outline,
                            color: AppColors.kRed, size: 20),
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
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, size: 16, color: AppColors.kRed),
              label: const Text(
                'Add More',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kRed),
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
                  // Return the created table data
                  final table = TableTier(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: tableNameController.text.isNotEmpty
                        ? tableNameController.text
                        : 'VIP Table',
                    totalTables: int.tryParse(totalTableController.text) ?? 1,
                    price: double.tryParse(tablePriceController.text) ?? 0,
                    maxPerPerson: int.tryParse(maxPersonsController.text) ?? 4,
                    isActive: tableActive,
                    reservationEnabled: reservationEnabled,
                    isDynamicPricing: dynamicPricing,
                  );
                  Navigator.pop(context, table);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}