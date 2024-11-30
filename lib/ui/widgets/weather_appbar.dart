import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';

class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  WeatherAppBar({Key? key})
      : preferredSize = const Size.fromHeight(60),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF6B8BF5),
      elevation: 0,
      title: const Text(
        'Weather Dashboard',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final weatherProvider =
                      Provider.of<WeatherProvider>(context, listen: false);

                  weatherProvider.sendBulkEmails();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bulk email sending completed.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B8BF5),
                  foregroundColor: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // no border
                  side: BorderSide.none,
                ),
                child: const Center(
                  child: Text(
                    "Notify All",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EmailSubscriptionDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EmailSubscriptionDialog extends StatefulWidget {
  @override
  _EmailSubscriptionDialogState createState() =>
      _EmailSubscriptionDialogState();
}

class _EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Weather Subscription'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input for email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            // Hyperlink to resend verification
            InkWell(
              onTap: () {
                if (_emailController.text.isNotEmpty) {
                  weatherProvider
                      .resendVerificationEmail(_emailController.text)
                      .then((_) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Verification email has been resent'),
                            ),
                          ))
                      .catchError((error) {
                    print('Error resending verification email: $error');
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your email first'),
                    ),
                  );
                }
              },
              child: const Text(
                'Resend verification email',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Subscribe button
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  weatherProvider.subscribeEmail(_emailController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please check your email to verify'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B8BF5),
                foregroundColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                minimumSize: Size(200, 60),
              ),
              child: const Center(
                child: Text(
                  "Subscribe",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Unsubscribe button
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  weatherProvider.unsubscribeEmail(_emailController.text);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Unsubscribed successfully!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B8777),
                foregroundColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                minimumSize: Size(200, 60),
              ),
              child: const Center(
                child: Text(
                  "Unsubscribe",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
