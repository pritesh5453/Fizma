// import 'package:fizmaa/Screens/add_event/add_volunteer/voluteer_list_screen.dart';
// import 'package:fizmaa/utils/appcolors.dart';
// import 'package:flutter/material.dart';

// class ReviewVolunteerDetailsScreen extends StatefulWidget {
//   const ReviewVolunteerDetailsScreen({Key? key}) : super(key: key);

//   @override
//   State<ReviewVolunteerDetailsScreen> createState() =>
//       _ReviewVolunteerDetailsScreenState();
// }

// class _ReviewVolunteerDetailsScreenState
//     extends State<ReviewVolunteerDetailsScreen> {
//   bool _showPassword = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new,
//               color: AppColors.textPrimary, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         titleSpacing: 0,
//         title: const Text(
//           'Review Volunteer Details',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: AppColors.screenGradient,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Top Header Info Box
//               _buildTopHeaderCard(),
//               const SizedBox(height: 16),

//               // 2. Volunteer Information Section
//               _buildSectionHeader(
//                 icon: Icons.person_outline,
//                 title: 'Volunteer Information',
//               ),
//               const SizedBox(height: 10),
//               _buildVolunteerInfoCard(),
//               const SizedBox(height: 16),

//               // 3. Permissions Summary Section
//               _buildSectionHeader(
//                 icon: Icons.shield_outlined,
//                 title: 'Permissions Summary',
//               ),
//               const SizedBox(height: 10),
//               _buildPermissionsSummaryCard(),
//               const SizedBox(height: 16),

//               // 4. What this volunteer cannot do Section
//               _buildSectionHeader(
//                 icon: Icons.lock_outline,
//                 title: 'What this volunteer cannot do',
//               ),
//               const SizedBox(height: 10),
//               _buildCannotDoCard(),
//               const SizedBox(height: 16),

//               // 5. Info Banner
//               _buildInfoBanner(),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),

//       // Bottom Buttons
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16.0),
//         color: AppColors.kWhite,
//         child: Row(
//           children: [
//             // Back Button
//             Expanded(
//               child: SizedBox(
//                 height: 48,
//                 child: OutlinedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Back',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryRed,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Confirm Button
//             Expanded(
//               child: SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, 
//                     MaterialPageRoute(builder: (context) => const VolunteersListScreen()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryRed,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Confirm',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.kWhite,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- 1. Top Header Card ---
//   Widget _buildTopHeaderCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: const BoxDecoration(
//               color: AppColors.actionRedBg,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.description_outlined,
//                 color: AppColors.primaryRed, size: 22),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'Review Volunteer Details',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Please review the information before Final Confirmation.',
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Section Header Helper
//   Widget _buildSectionHeader({required IconData icon, required String title}) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.primaryRed),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }

//   // --- 2. Volunteer Info Grid Card ---
//   Widget _buildVolunteerInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.storefront_outlined,
//                   label: 'Registration Desk',
//                   value: 'Main Desk',
//                 ),
//               ),
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.account_circle_outlined,
//                   label: 'Account Type',
//                   value: 'Volunteer',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.person_outline,
//                   label: 'Volunteer Name',
//                   value: 'Rahul Sharma',
//                 ),
//               ),
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.badge_outlined,
//                   label: 'Volunteer ID',
//                   value: 'VOL-1024',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.phone_outlined,
//                   label: 'Phone Number',
//                   value: '+91 98765 43210',
//                 ),
//               ),
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.email_outlined,
//                   label: 'Email Address',
//                   value: 'rahul@fizmaa.com',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailTile(
//                   icon: Icons.lock_outline,
//                   label: 'Login Method',
//                   value: 'Set Password',
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Password',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Text(
//                           _showPassword ? 'password123' : '••••••••',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _showPassword = !_showPassword;
//                             });
//                           },
//                           child: Icon(
//                             _showPassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                             size: 16,
//                             color: AppColors.textSecondary,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailTile({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: const BoxDecoration(
//             color: AppColors.actionRedBg,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: AppColors.primaryRed, size: 16),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // --- 3. Permissions Summary Card ---
//   Widget _buildPermissionsSummaryCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Column(
//         children: [
//           _buildPermissionRow(
//             icon: Icons.remove_red_eye_outlined,
//             title: 'View Tickets',
//             subtitle: 'Can view ticket list and details',
//           ),
//           const Divider(height: 1, color: AppColors.cardBorder),
//           _buildPermissionRow(
//             icon: Icons.qr_code_scanner,
//             title: 'Scan Tickets',
//             subtitle: 'Can scan and validate tickets',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionRow({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               color: AppColors.actionRedBg,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: AppColors.primaryRed, size: 16),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.check_circle_outline,
//               color: AppColors.statGreenFg, size: 20),
//         ],
//       ),
//     );
//   }

//   // --- 4. What this volunteer cannot do Card ---
//   Widget _buildCannotDoCard() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Column(
//         children: [
//           _buildCannotDoRow('Cannot edit event, tickets, pricing or any settings'),
//           const SizedBox(height: 10),
//           _buildCannotDoRow('Cannot access revenue, payouts or financial details'),
//           const SizedBox(height: 10),
//           _buildCannotDoRow('Cannot manage other volunteers'),
//         ],
//       ),
//     );
//   }

//   Widget _buildCannotDoRow(String text) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 11,
//               color: AppColors.textPrimary,
//             ),
//           ),
//         ),
//         const Icon(Icons.cancel_outlined,
//             color: AppColors.chipDeleteFg, size: 18),
//       ],
//     );
//   }

//   // --- 5. Bottom Info Banner ---
//   Widget _buildInfoBanner() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.cardBorder, width: 1),
//       ),
//       child: Row(
//         children: const [
//           Icon(Icons.info, color: Colors.blueAccent, size: 20),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               'An invitation will be sent to the volunteer to access this event.',
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }