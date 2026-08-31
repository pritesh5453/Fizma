// import 'package:fizmaa/Screens/add_event/add_volunteer/review_voluteer.dart';
// import 'package:fizmaa/utils/appcolors.dart';
// import 'package:flutter/material.dart';

// class AddVolunteerScreen extends StatefulWidget {
//   const AddVolunteerScreen({Key? key}) : super(key: key);

//   @override
//   State<AddVolunteerScreen> createState() => _AddVolunteerScreenState();
// }

// class _AddVolunteerScreenState extends State<AddVolunteerScreen> {
//   // Controllers
//   final TextEditingController _nameController =
//       TextEditingController(text: 'Rahul Sharma');
//   final TextEditingController _phoneController =
//       TextEditingController(text: '+91 9876543210');
//   final TextEditingController _emailController =
//       TextEditingController(text: 'rahul@fizmaa.com');
//   final TextEditingController _passwordController =
//       TextEditingController(text: 'password123');

//   // Form State
//   String _selectedDesk = 'Main Desk';
//   int _accessType = 0; // 0: Set Password, 1: Send Invite Link
//   bool _canViewTickets = true;
//   bool _canScanTickets = true;
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         titleSpacing: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Add Volunteer',
//               style: TextStyle(
//                 color: AppColors.textPrimary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               'Add registration desk volunteer for this event',
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         decoration: AppColors.screenGradient,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // 1. Event Summary Card
//               _buildEventCard(),
//               const SizedBox(height: 16),

//               // 2. Volunteer Information Card
//               _buildVolunteerInfoCard(),
//               const SizedBox(height: 16),

//               // 3. Volunteer Permissions Card
//               _buildPermissionsCard(),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16.0),
//         color: AppColors.kWhite,
//         child: SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, 
//               MaterialPageRoute(builder: (context) => const ReviewVolunteerDetailsScreen()));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryRed,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//             child: const Text(
//               'Save & Proceed',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.kWhite,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Event Summary Card Widget ---
//   Widget _buildEventCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               'https://picsum.photos/200',
//               width: 70,
//               height: 70,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Bhajan Concert',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: const [
//                     Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.primaryRed),
//                     SizedBox(width: 4),
//                     Text(
//                       '29 Jan 2025 - 30 Jan 2025',
//                       style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: const [
//                     Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
//                     SizedBox(width: 4),
//                     Text(
//                       'City Convention Hall, Surat',
//                       style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Volunteer Info Section ---
//   Widget _buildVolunteerInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: const BoxDecoration(
//                   color: AppColors.actionRedBg,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.person_outline, color: AppColors.primaryRed, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Volunteer Information',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                   ),
//                   Text(
//                     'Enter basic details of the volunteer.',
//                     style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Dropdown
//           _buildLabel('Registration Desk'),
//           const SizedBox(height: 6),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: AppColors.kBorder),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedDesk,
//                 isExpanded: true,
//                 icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
//                 items: ['Main Desk', 'VIP Desk', 'Help Desk'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.storefront, color: AppColors.primaryRed, size: 18),
//                         const SizedBox(width: 8),
//                         Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   if (val != null) setState(() => _selectedDesk = val);
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Text Fields
//           _buildLabel('Volunteer Name'),
//           const SizedBox(height: 6),
//           _buildTextField(_nameController),

//           const SizedBox(height: 12),
//           _buildLabel('Phone Number'),
//           const SizedBox(height: 6),
//           _buildTextField(_phoneController, keyboardType: TextInputType.phone),

//           const SizedBox(height: 12),
//           _buildLabel('Email Address (Optional)'),
//           const SizedBox(height: 6),
//           _buildTextField(_emailController, keyboardType: TextInputType.emailAddress),

//           const SizedBox(height: 12),
//           _buildLabel('Password / Access'),
//           const SizedBox(height: 6),

//           // Radio Selection Cards
//           Row(
//             children: [
//               Expanded(
//                 child: _buildRadioOption(
//                   index: 0,
//                   title: 'Set Password',
//                   subtitle: 'Create a password for this volunteer',
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _buildRadioOption(
//                   index: 1,
//                   title: 'Send Invite Link',
//                   subtitle: 'Send login invite on email / phone',
//                 ),
//               ),
//             ],
//           ),

//           if (_accessType == 0) ...[
//             const SizedBox(height: 12),
//             _buildLabel('Password'),
//             const SizedBox(height: 6),
//             TextField(
//               controller: _passwordController,
//               obscureText: _obscurePassword,
//               style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.kBorder),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.kBorder),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                     color: AppColors.primaryRed,
//                     size: 20,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ]
//         ],
//       ),
//     );
//   }

//   // --- Volunteer Permissions Section ---
//   Widget _buildPermissionsCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: const BoxDecoration(
//                   color: AppColors.actionRedBg,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.shield_outlined, color: AppColors.primaryRed, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Volunteer Permissions',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                   ),
//                   Text(
//                     'This volunteer will have the following access.',
//                     style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Toggles
//           _buildSwitchRow(
//             icon: Icons.remove_red_eye_outlined,
//             title: 'View Tickets',
//             subtitle: 'Can view ticket list and details',
//             value: _canViewTickets,
//             onChanged: (val) => setState(() => _canViewTickets = val),
//           ),
//           const SizedBox(height: 12),
//           _buildSwitchRow(
//             icon: Icons.qr_code_scanner,
//             title: 'Scan Tickets',
//             subtitle: 'Can scan and validate tickets',
//             value: _canScanTickets,
//             onChanged: (val) => setState(() => _canScanTickets = val),
//           ),
//           const SizedBox(height: 16),

//           // Note Box
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.kPinkLight,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.error, color: AppColors.primaryRed, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Note',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.primaryRed,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         'Volunteer will not be able to edit event, tickets, pricing or any other settings.',
//                         style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helpers
//   Widget _buildLabel(String label) {
//     return Text(
//       label,
//       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.kBorder),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.kBorder),
//         ),
//       ),
//     );
//   }

//   Widget _buildRadioOption({
//     required int index,
//     required String title,
//     required String subtitle,
//   }) {
//     bool isSelected = _accessType == index;
//     return GestureDetector(
//       onTap: () => setState(() => _accessType = index),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: AppColors.kWhite,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryRed : AppColors.kBorder,
//             width: isSelected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(
//               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: isSelected ? AppColors.primaryRed : AppColors.textSecondary,
//               size: 18,
//             ),
//             const SizedBox(width: 6),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSwitchRow({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool value,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.primaryRed, size: 20),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
//               ),
//               Text(
//                 subtitle,
//                 style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
//               ),
//             ],
//           ),
//         ),
//         Switch(
//           value: value,
//           activeColor: AppColors.kWhite,
//           activeTrackColor: AppColors.primaryRed,
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
// }