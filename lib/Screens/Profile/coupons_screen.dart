import 'package:fizmaa/Screens/Profile/create_coupons_screen.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/coupons/all_coupons/get_all_coupons_svc.dart';
import 'package:fizmaa/models_n_services/coupons/coupons_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CouponsMainScreen extends StatefulWidget {
  const CouponsMainScreen({Key? key}) : super(key: key);

  @override
  State<CouponsMainScreen> createState() => _CouponsMainScreenState();
}

class _CouponsMainScreenState extends State<CouponsMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final CouponApiService _couponService; // ✅ new class name

  List<CouponData> _coupons = [];
  bool _isLoading = true;
  String? _error;

  static const List<String?> _statuses = [null, 'active', 'upcoming', 'expired'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);

    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _couponService = CouponApiService(dio); // ✅ new class name
    _fetchCoupons();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _statuses[_tabController.index];
    _fetchCoupons(status: status);
  }

  Future<void> _fetchCoupons({String? status}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _couponService.getCoupons(status: status);
      setState(() {
        _coupons = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _showCreateCouponBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateCouponBottomSheet(),
    ).then((result) {
      if (result == true) {
        final status = _statuses[_tabController.index];
        _fetchCoupons(status: status);
      }
    });
  }

  String _formatDiscount(CouponData coupon) {
    final value = coupon.discountValue;
    if (coupon.discountType == 'percentage') {
      return '$value% OFF';
    } else {
      return '₹$value OFF';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade100;
      case 'expired':
        return Colors.grey.shade200;
      case 'upcoming':
        return Colors.lightBlue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade800;
      case 'expired':
        return Colors.grey.shade700;
      case 'upcoming':
        return Colors.lightBlue.shade800;
      default:
        return Colors.grey.shade700;
    }
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
            onPressed: () => Navigator.of(context).maybePop(),
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
              onPressed: _showCreateCouponBottomSheet,
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF3B30),
          labelColor: const Color(0xFFFF3B30),
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Failed to load coupons', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchCoupons(status: _statuses[_tabController.index]),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF3B30)),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_offer_outlined, color: Colors.grey, size: 64),
            const SizedBox(height: 16),
            const Text('No coupons found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Create your first coupon by tapping the + button',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _coupons.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final coupon = _coupons[index];
        final progress = coupon.usageLimit > 0 ? coupon.usedCount / coupon.usageLimit : 0.0;
        final statusDisplay = coupon.status.toUpperCase();
        final statusColor = _getStatusColor(coupon.status);
        final statusTextColor = _getStatusTextColor(coupon.status);

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
                        Text(coupon.couponCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(coupon.couponName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDiscount(coupon),
                        style: const TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusDisplay,
                          style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.bold),
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
                          text: '${coupon.usedCount}/${coupon.usageLimit}',
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
                          text: '${coupon.perUserLimit}x',
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
                          text: coupon.expiryDate.split('T')[0],
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
    );
  }
}