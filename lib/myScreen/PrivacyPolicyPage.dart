import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool isLoading = true;
  String privacyPolicyData = '';

  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      privacyPolicyData = '''

1. Introduction
Welcome to our Privacy Policy page. Your privacy is critically important to us. This document outlines the types of information we collect, how we use it, and the steps we take to ensure your data remains safe. Our commitment to safeguarding your personal information underpins all of our business processes.

2. Information We Collect
We collect the following types of data to provide a seamless and personalized experience:
- **Personal Information**: This includes your name, email address, phone number, billing address, shipping address, and any other details you provide during registration or purchases.
- **Usage Data**: Information such as the features you access, the time spent on our app, and user interactions, which help us understand and improve your experience.
- **Device Information**: Includes your device type, operating system, browser type, IP address, and unique device identifiers.
- **Payment Information**: When making purchases, we may collect payment details such as card numbers or wallet information (encrypted and secure).

3. How We Use Your Information
We use your information in the following ways:
- **Enhancement of Services**: To provide a personalized and user-friendly experience.
- **Communication**: To send important updates, promotional content, or responses to inquiries.
- **Analytics and Research**: To analyze user behavior for improving app performance and introducing new features.
- **Transaction Processing**: To handle orders, process payments, and ensure accurate billing.

4. Data Security
Protecting your data is our priority. Our security measures include:
- **End-to-End Encryption**: Ensuring secure data transmission.
- **Access Controls**: Restricting data access to authorized personnel only.
- **Data Anonymization**: Where possible, we anonymize your information to protect your identity.
- **Regular Security Audits**: Conducting regular assessments of our systems to identify and mitigate vulnerabilities.

5. Cookies and Tracking Technologies
To improve your experience, we use:
- **Cookies**: Small data files stored on your device to remember your preferences.
- **Tracking Pixels**: To measure the effectiveness of our marketing campaigns.
- **Log Files**: To record and analyze user behavior on our platform.

6. Sharing Your Information
We do not sell your personal data. However, we may share your information with trusted entities:
- **Service Providers**: Partners who assist in payment processing, order fulfillment, or marketing campaigns.
- **Law Enforcement**: If required by law or to protect our legal rights.

7. Retention of Data
Your data will be retained as long as necessary for the purposes outlined in this policy or as required by law. When no longer needed, we will securely delete or anonymize your information.

8. Your Rights
We are committed to giving you control over your personal data:
- **Access**: You can request a copy of the data we hold about you.
- **Correction**: Update inaccurate or incomplete information.
- **Deletion**: Request the removal of your personal data from our systems.
- **Restriction**: Limit the processing of your data under certain conditions.

9. Changes to This Privacy Policy
We may update this Privacy Policy periodically to reflect changes in laws or services. Any significant updates will be communicated through email or in-app notifications. We encourage you to review this policy regularly.

10. Third-Party Links
Our app may contain links to third-party websites or services. Please note that we are not responsible for the privacy practices of these external entities. We recommend reviewing their privacy policies.

11. International Data Transfers
If you are accessing our app from outside of India, please be aware that your information may be transferred to, stored, and processed in India. We ensure that all such transfers comply with applicable data protection laws.

''';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        foregroundColor: Colors.white,
        backgroundColor: primaryColors,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: privacyPolicyData
                      .split('\n')
                      .map(
                        (line) => line.startsWith(RegExp(r'\d\. '))
                            ? Text(
                                line,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  line,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}
