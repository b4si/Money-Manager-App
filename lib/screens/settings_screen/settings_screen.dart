// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=T0qbFgbFhg0';
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
<<<<<<< HEAD
            title: const Text('Terms and Conditions'),
            onTap: () {},
=======
            title: const Text(
              'Terms and conditions',
            ),
            onTap: (() {
              _launchURL();
            }),
>>>>>>> bfc8254b05142acf8af22dcb5d2c381558654842
          ),
          ListTile(
            title: (const Text('Reset all')),
            trailing: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.only(right: 15, bottom: 12),
                      content: const Text('Reset App'),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            TransactionDB.instance.deleteAllTransactions();
                            CategoryDB.instance.deleteAllCategory();

                            Navigator.of(context).pushAndRemoveUntil(
                                (MaterialPageRoute(builder: ((context) {
                                  return SplashScreen();
                                }))),
                                (route) => false);
                          },
                          child: const Text('Yes'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  });
            }),
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: (() {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return const Center(
                      child: Text(
                        'Created by Muhammed Basil K',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }
}
