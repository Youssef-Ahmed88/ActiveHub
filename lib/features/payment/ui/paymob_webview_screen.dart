import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';

class PaymobWebViewScreen extends StatefulWidget {
  final String iframeUrl;
  final int bookingId;
  final double amount;

  const PaymobWebViewScreen({
    super.key,
    required this.iframeUrl,
    required this.bookingId,
    required this.amount,
  });

  @override
  State<PaymobWebViewScreen> createState() => _PaymobWebViewScreenState();
}

class _PaymobWebViewScreenState extends State<PaymobWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentHandled = false; // ✅ عشان منتعاملش مع الـ success أكتر من مرة

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            // ✅ بعض الـ payment gateways بترجع success في الـ page نفسها
            if (!_paymentHandled &&
                (url.contains('success=true') ||
                    url.contains('txn_response_code=APPROVED'))) {
              _paymentHandled = true;
              _confirmBookingAndShowSuccess();
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (!_paymentHandled &&
                (url.contains('success=true') ||
                    url.contains('txn_response_code=APPROVED'))) {
              _paymentHandled = true;
              _confirmBookingAndShowSuccess();
              return NavigationDecision.prevent;
            }
            if (url.contains('success=false') ||
                url.contains('txn_response_code=DECLINED')) {
              _showFailureDialog();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.iframeUrl));
  }

  // ✅ الدالة الجديدة — بتكلم الـ backend وتـ confirm الـ booking
  Future<void> _confirmBookingAndShowSuccess() async {
    try {
      final dio = DioFactory.getDio();
      await dio.patch('/bookings/${widget.bookingId}/confirm');
      debugPrint('✅ Booking ${widget.bookingId} confirmed successfully');
    } catch (e) {
      debugPrint('⚠️ Could not confirm booking via API: $e');
      // مش هنوقف الـ flow لو الـ API call فشلت
    }
    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'EGP ${widget.amount.toStringAsFixed(0)} paid successfully',
              style: const TextStyle(
                color: ColorsManager.mutedText,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeScreen,
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Payment Failed!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.cardBg,
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
