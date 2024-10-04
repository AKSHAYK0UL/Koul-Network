import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  static const routeName = "Privacy";
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Privacy Policy",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'Introduction\n'),
                TextSpan(
                    text:
                        'KOUL Network ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our payment services. By using KOUL Network, you agree to the collection and use of information in accordance with this policy.\n'),
                TextSpan(text: '1. Information We Collect\n'),
                TextSpan(
                    text:
                        'To provide our services, we collect only the information necessary to create and manage your account, facilitate transactions, and improve our services. This may include:\n'),
                TextSpan(
                    text:
                        'Personal Information: Your name, email address, phone number, and payment details.Transaction Information: Details about the payments you make and receive, including the amount, date, and recipient.\n'),
                TextSpan(text: '2. How We Use Your Information\n'),
                TextSpan(text: 'We use your information to:\n'),
                TextSpan(
                    text:
                        'Facilitate transactions on KOUL Network.\nVerify your identity and maintain the security of your account.\nImprove and personalize our services.\nCommunicate with you about updates, promotions, and important notices.\n'),
                TextSpan(text: '3. Data Security\n'),
                TextSpan(
                    text:
                        'We take the security of your data seriously. All personal information and transaction data are stored using industry-standard encryption. Additionally, we implement the following security measures:\n'),
                TextSpan(
                    text:
                        'Data Hashing: Sensitive data, such as your payment details and passwords, are hashed before storage. This ensures that even in the unlikely event of a data breach, your information remains secure and unreadable.\n'),
                TextSpan(
                    text:
                        'Access Controls: Access to your information is restricted to authorized personnel only, and we regularly audit our security practices to ensure compliance with industry standards.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
