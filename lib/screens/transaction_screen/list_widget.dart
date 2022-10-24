import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../catagory_model/category_model.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  ValueNotifier<List<TransactionModel>> transactions =
      TransactionDB.instance.transactionListNotifier;

  ValueNotifier<List<TransactionModel>> foundTransactions =
      [] as ValueNotifier<List<TransactionModel>>;
  @override
  void initState() {
    foundTransactions = transactions;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    ValueNotifier<List<TransactionModel>> results =
        [] as ValueNotifier<List<TransactionModel>>;
    if (enteredKeyword.isEmpty) {
      results = foundTransactions;
    } else {
      results = transactions.value
          .where(
            (user) => user.category.name.trim().toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList() as ValueNotifier<List<TransactionModel>>;
    }
    setState(() {
      foundTransactions = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: foundTransactions,
      builder: (BuildContext context, List<TransactionModel> newList, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  onChanged: ((value) => _runFilter(value)),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            ListView.separated(
              itemBuilder: ((context, index) {
                final transactionList = newList[index];

                return Slidable(
                  key: Key(transactionList.id!),
                  startActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance
                            .deleteTransaction(transactionList.id!);
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                  ]),
                  child: ListTile(
                    title: Text(transactionList.category.name),
                    subtitle: Text(
                      parseDate(transactionList.date),
                    ),
                    trailing: transactionList.type == CategoryType.income
                        ? Text(
                            '₹${transactionList.amount.toString()}',
                            style: const TextStyle(color: Colors.green),
                          )
                        : Text(
                            '₹${transactionList.amount.toString()}',
                            style: const TextStyle(color: Colors.red),
                          ),
                  ),
                );
              }),
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                );
              },
              itemCount: newList.length,
            ),
          ],
        );
      },
    );
  }
}

String parseDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
