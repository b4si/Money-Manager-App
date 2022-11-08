import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../catagory_model/category_model.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';
import '../form_screen/form_screen.dart';
import '../transaction_screen/transaction_screen.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder:
              (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
            return newList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'No Transactions',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: (newList.length >= 6 ? 6 : newList.length),
                    itemBuilder: ((ctx, index) {
                      final transactionList = newList[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                              title: Text(
                                transactionList.category.name,
                              ),
                              subtitle: Text(
                                parseDate(
                                  transactionList.date,
                                ),
                              ),
                              trailing: transactionList.type ==
                                      CategoryType.income
                                  ? Text(
                                      (('₹${transactionList.amount.toString()}')),
                                      style:
                                          const TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      (('₹${transactionList.amount.toString()}')),
                                      style: const TextStyle(color: Colors.red),
                                    )),
                        ),
                      );
                    }),
                  );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: (() {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return const FormScreen();
                      })));
                    }),
                    backgroundColor: const Color(0xFF15485D),
                    child: const Icon(FontAwesomeIcons.plus),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
