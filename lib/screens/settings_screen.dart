import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
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
            onTap: () {},
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) {
                                return const SplashScreen();
                              }),
                            );
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
            onTap: (() {}),
          ),
        ],
      ),
    );
  }
}
