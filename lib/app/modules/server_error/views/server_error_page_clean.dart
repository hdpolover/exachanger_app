import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:exachanger_get_app/app/modules/server_error/controllers/server_error_controller.dart';

class ServerErrorPage extends StatelessWidget {
  const ServerErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServerErrorController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Icon(
                  Icons.cloud_off_outlined,
                  size: 120,
                  color: Colors.red.shade400,
                ),

                SizedBox(height: 32),

                // Main Title
                Text(
                  'Service Unavailable',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                // Error Code
                if (controller.errorCode.value.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      'Error Code: ${controller.errorCode.value}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),

                SizedBox(height: 24),

                // Main Error Message
                Text(
                  controller.serverErrorMessage.value.isNotEmpty
                      ? controller.serverErrorMessage.value
                      : 'Our servers are currently experiencing issues. The application cannot function properly at this time.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                // What users can do
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade600,
                        size: 24,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'What you can do:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Check your internet connection\n'
                        '• Wait a few minutes and try again\n'
                        '• Contact support if the issue persists',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Action Buttons
                Column(
                  children: [
                    // Retry Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isRetrying.value
                            ? null
                            : () => controller.retryConnection(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.isRetrying.value) ...[
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Retrying...'),
                            ] else ...[
                              Icon(Icons.refresh),
                              SizedBox(width: 8),
                              Text(
                                'Try Again (${controller.retryAttempts.value}/${controller.maxRetryAttempts})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Contact Support Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _contactSupport(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          side: BorderSide(color: Colors.red.shade600),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.support_agent),
                            SizedBox(width: 8),
                            Text(
                              'Contact Support',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Exit App Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _exitApp(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 8),
                            Text(
                              'Exit App',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Technical Details (expandable)
                if (controller.technicalDetails.value.isNotEmpty) ...[
                  SizedBox(height: 24),
                  ExpansionTile(
                    title: Text(
                      'Technical Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.technicalDetails.value,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _contactSupport() {
    // TODO: Implement contact support functionality
    // This could open email, phone, or in-app chat
    Get.snackbar(
      'Contact Support',
      'Please email support@exchanger.com or call +1-800-EXCHANGE',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }

  void _exitApp() {
    // Close the app
    SystemNavigator.pop();
  }
}
