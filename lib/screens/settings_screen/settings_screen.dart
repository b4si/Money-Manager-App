import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/screens/settings_screen/terms_and_conditions.dart';
import 'package:money_manager/screens/splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('Terms and Conditions'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) {
                    return const TermsAndConditions();
                  }),
                ),
              );
            },
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
                                  return const SplashScreen();
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
