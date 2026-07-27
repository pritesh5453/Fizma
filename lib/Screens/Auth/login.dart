// import 'package:fizma/Screens/Auth/signup_screen.dart';
// import 'package:fizma/Screens/home/homescreen.dart';
// import 'package:fizma/Screens/navbar/navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// /// ============================================================
// /// ASSET PATHS — just replace these with your own image paths.
// /// Add more images to any list for a longer, smoother loop.
// /// ============================================================
// class AppAssets {
//   static const List<String> leftColumnImages = [
//     'assets/images/splash1.png',
//     'assets/images/splash2.png',
//   ];

//   static const List<String> middleColumnImages = [
//     'assets/images/splash3.png',
//     'assets/images/splash4.png',
//     'assets/images/splash5.png',
//   ];

//   static const List<String> rightColumnImages = [
//     'assets/images/splash6.png',
//     'assets/images/splash7.png',
//   ];

//   // Optional social icons — swap with your own PNG/SVG assets.
//   static const String facebookIcon = 'assets/icons/facebook.png';
//   static const String googleIcon = 'assets/icons/google.png';
// }

// /// ============================================================
// /// SIGN IN SCREEN
// ///
// /// Layout strategy (this is the part that was broken before):
// ///   1. A full-screen WHITE container is the base layer. It is sized
// ///      with Positioned.fill, so it can never collapse to zero height.
// ///      It holds ALL the real content (Sign in, fields, buttons...),
// ///      pushed down by a top spacer sized to the gallery's height.
// ///   2. The photo gallery sits ON TOP of that, in its own fixed-height
// ///      Positioned box, clipped with a wavy BOTTOM edge — so the wave
// ///      cuts into the photos and reveals the white layer underneath.
// ///
// /// Because the white layer is always full-screen, the "Sign in" card
// /// content can never disappear, no matter what the gallery does.
// /// ============================================================
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController _emailController =
//       TextEditingController(text: 'demo@gmail.com');
//   final TextEditingController _passwordController =
//       TextEditingController(text: '1234567');
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     // Height of the photo gallery area at the top of the screen.
//     final galleryHeight = screenHeight * 0.42;
//     // How far down (within the gallery box) the wave dips at its
//     // lowest point on the left — used to know where "Sign in" starts.
//     final contentTopSpacer = galleryHeight * 0.74;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // ---------- Layer 1: full-screen white content (base) ----------
//           Positioned.fill(
//             child: Container(
//               color: Colors.white,
//               child: SafeArea(
//                 bottom: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: contentTopSpacer),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Sign in',
//                               style: TextStyle(
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF2B2B2B),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               width: 40,
//                               height: 3,
//                               color: const Color(0xFFE05A5A),
//                             ),
//                             const SizedBox(height: 28),

//                             _fieldLabel('EMAIL/ PHONE NO'),
//                             const SizedBox(height: 8),
//                             _RoundedTextField(
//                               controller: _emailController,
//                               hintText: 'demo@gmail.com',
//                             ),
//                             const SizedBox(height: 20),

//                             _fieldLabel('PASSWORD'),
//                             const SizedBox(height: 8),
//                             _RoundedTextField(
//                               controller: _passwordController,
//                               obscureText: _obscurePassword,
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.black45,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 10),

//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {},
//                                 style: TextButton.styleFrom(
//                                   padding: EdgeInsets.zero,
//                                   minimumSize: const Size(0, 0),
//                                   tapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: const Text(
//                                   'Forget Password?',
//                                   style: TextStyle(
//                                     color: Color(0xFF3E7BFA),
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 18),

//                             _LoginButton(onTap: () {
//                               Navigator.push(context, 
//                               MaterialPageRoute(builder: (context) => const EventsNavBar()));
//                             }),
//                             const SizedBox(height: 20),

//                             Row(
//                               children: const [
//                                 Expanded(
//                                     child:
//                                         Divider(color: Color(0xFFE0E0E0))),
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.symmetric(horizontal: 12),
//                                   child: Text(
//                                     'Or',
//                                     style: TextStyle(color: Colors.black45),
//                                   ),
//                                 ),
//                                 Expanded(
//                                     child:
//                                         Divider(color: Color(0xFFE0E0E0))),
//                               ],
//                             ),
//                             const SizedBox(height: 18),

//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _SocialButton(
//                                     iconAsset: AppAssets.facebookIcon,
//                                     fallbackIcon: Icons.facebook,
//                                     fallbackColor: const Color(0xFF1877F2),
//                                     label: 'Facebook',
//                                     onTap: () {},
//                                   ),
//                                 ),
//                                 const SizedBox(width: 14),
//                                 Expanded(
//                                   child: _SocialButton(
//                                     iconAsset: AppAssets.googleIcon,
//                                     fallbackIcon: Icons.g_mobiledata,
//                                     fallbackColor: const Color(0xFFEA4335),
//                                     label: 'Google',
//                                     onTap: () {},
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 22),

//                             Center(
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text(
//                                     "Don't have account? ",
//                                     style: TextStyle(
//                                       color: Colors.black54,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(context, 
//                                       MaterialPageRoute(builder: (context) => const CreateAccountScreen()));
//                                     },
//                                     child: const Text(
//                                       'Sign Up',
//                                       style: TextStyle(
//                                         color: Color(0xFF3E7BFA),
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // ---------- Layer 2: scrolling photo gallery (foreground) ----------
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: galleryHeight,
//             child: ClipPath(
//               clipper: _GalleryWaveClipper(),
//               child: Container(
//                 color: const Color(0xFFFDF1F1),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 34,
//                       child: _MarqueeImageColumn(
//                         images: AppAssets.leftColumnImages,
//                         itemHeight: 165,
//                         scrollUp: false,
//                         speed: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       flex: 32,
//                       child: _MarqueeImageColumn(
//                         images: AppAssets.middleColumnImages,
//                         itemHeight: 140,
//                         scrollUp: true,
//                         speed: 16,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       flex: 34,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 36),
//                         child: _MarqueeImageColumn(
//                           images: AppAssets.rightColumnImages,
//                           itemHeight: 165,
//                           scrollUp: false,
//                           speed: 10,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _fieldLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.w600,
//         color: Colors.black54,
//         letterSpacing: 0.5,
//       ),
//     );
//   }
// }

// /// ============================================================
// /// ROUNDED TEXT FIELD
// /// ============================================================
// class _RoundedTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final String? hintText;

//   const _RoundedTextField({
//     required this.controller,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.hintText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFFBE7E9),
//         borderRadius: BorderRadius.circular(28),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(color: Colors.black87, fontSize: 15),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.black38),
//           suffixIcon: suffixIcon,
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         ),
//       ),
//     );
//   }
// }

// /// ============================================================
// /// GRADIENT LOGIN BUTTON
// /// ============================================================
// class _LoginButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _LoginButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFEF5350), Color(0xFFB71C1C)],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFB71C1C).withOpacity(0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         alignment: Alignment.center,
//         child: const Text(
//           'Log in',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ============================================================
// /// SOCIAL LOGIN BUTTON (Facebook / Google)
// /// ============================================================
// class _SocialButton extends StatelessWidget {
//   final String iconAsset;
//   final IconData fallbackIcon;
//   final Color fallbackColor;
//   final String label;
//   final VoidCallback onTap;

//   const _SocialButton({
//     required this.iconAsset,
//     required this.fallbackIcon,
//     required this.fallbackColor,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: const Color(0xFFFBE7E9),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               iconAsset,
//               width: 20,
//               height: 20,
//               errorBuilder: (context, error, stackTrace) =>
//                   Icon(fallbackIcon, size: 20, color: fallbackColor),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ============================================================
// /// GALLERY WAVE CLIPPER
// /// Clips the photo-gallery box so its BOTTOM edge is wavy: mostly
// /// flat/high on the right (cut short, revealing white early) and
// /// dipping low on the left (showing more of the photos). This is
// /// the mirror image of a "wave cut into the top of a card" — here
// /// it's cut into the BOTTOM of the gallery box instead, which is
// /// visually identical but far more layout-safe.
// /// ============================================================
// class _GalleryWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final w = size.width;
//     final h = size.height;
//     final path = Path();
//     path.moveTo(0, 0);
//     path.lineTo(w, 0);
//     path.lineTo(w, h * 0.945);
//     path.lineTo(w * 0.55, h * 0.945);
//     path.quadraticBezierTo(w * 0.40, h * 1.0, w * 0.30, h * 0.88);
//     path.quadraticBezierTo(w * 0.14, h * 0.70, 0, h * 0.76);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

// /// ============================================================
// /// INFINITE AUTO-SCROLLING IMAGE COLUMN (the "moving images")
// /// ============================================================
// ///
// /// Renders [images] stacked vertically and continuously scrolls them
// /// up or down forever, looping seamlessly. No user interaction needed.
// /// Uses LayoutBuilder so it always fills whatever height its parent
// /// gives it, regardless of how many images are in the list.
// class _MarqueeImageColumn extends StatefulWidget {
//   final List<String> images;
//   final double itemHeight;
//   final bool scrollUp;
//   final double speed; // pixels per second
//   final double spacing;
//   final double borderRadius;

//   const _MarqueeImageColumn({
//     required this.images,
//     required this.itemHeight,
//     this.scrollUp = true,
//     this.speed = 15,
//     this.spacing = 8,
//     this.borderRadius = 14,
//   });

//   @override
//   State<_MarqueeImageColumn> createState() => _MarqueeImageColumnState();
// }

// class _MarqueeImageColumnState extends State<_MarqueeImageColumn>
//     with SingleTickerProviderStateMixin {
//   late final Ticker _ticker;
//   double _offset = 0;
//   Duration _lastElapsed = Duration.zero;

//   double get _setHeight =>
//       widget.images.length * (widget.itemHeight + widget.spacing);

//   @override
//   void initState() {
//     super.initState();
//     _ticker = createTicker(_onTick)..start();
//   }

//   void _onTick(Duration elapsed) {
//     final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
//     _lastElapsed = elapsed;
//     final setHeight = _setHeight;
//     if (setHeight <= 0) return;

//     setState(() {
//       _offset += widget.speed * dt;
//       if (_offset >= setHeight) {
//         _offset -= setHeight;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _ticker.dispose();
//     super.dispose();
//   }

//   Widget _buildTile(String path) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: widget.spacing),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(widget.borderRadius),
//         child: Image.asset(
//           path,
//           height: widget.itemHeight,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) => Container(
//             height: widget.itemHeight,
//             color: Colors.grey.shade200,
//             alignment: Alignment.center,
//             child: const Icon(Icons.image_outlined, color: Colors.grey),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.images.isEmpty) return const SizedBox.shrink();

//     final doubledImages = [...widget.images, ...widget.images];
//     final setHeight = _setHeight;
//     final translateY = widget.scrollUp ? -_offset : (_offset - setHeight);

//     // Fills exactly whatever height the parent (the gallery Row) gives it.
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return ClipRect(
//           child: SizedBox(
//             height: constraints.maxHeight,
//             width: double.infinity,
//             child: OverflowBox(
//               maxHeight: double.infinity,
//               alignment: Alignment.topCenter,
//               child: Transform.translate(
//                 offset: Offset(0, translateY),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: doubledImages.map(_buildTile).toList(),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }