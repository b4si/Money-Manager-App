// ignore_for_file: unused_local_variable, override_on_non_overriding_member, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../catagory_model/category_model.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  List<TransactionModel> transactions =
      TransactionDB.instance.transactionListNotifier.value;

  List<TransactionModel> foundTransactions = [];

  @override
  void initState() {
    foundTransactions = transactions;

    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<TransactionModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = transactions;
    } else {
      results = transactions
          .where(
            (user) => user.category.name.trim().toLowerCase().contains(
                  enteredKeyword.trim().toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      foundTransactions = results;
    });
  }

  // void todaysdate(String selecteddate) {
  //   List<TransactionModel> results = [];
  //   if (selecteddate == DateTime.now().day) {
  //     results = transactions;
  //   }
  //   setState(() {
  //     foundTransactions = results;
  //   });
  // }

  void monthlyTransactionList() {
    List<TransactionModel> results = [];
    for (var i = 0; i < transactions.length; i++) {
      if (transactions[i].date == DateTime.now()) {}
    }
  }

  @override
  final TextEditingController _searchController = TextEditingController();
  String? selectedItem;
  int? _value1;
  int _value2 = 1;
  int? _value3;
  int _value4 = 1;

  List<String> items = [
    'All',
    'Income',
    'Expense',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transactions'),
        backgroundColor: const Color(0xFF15485D),
      ),
      body: Column(
        children: [
          ListTile(
            leading: DropdownButton(
              value: _value4,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: const Text('All'),
                  onTap: () {
                    setState(() {
                      foundTransactions = transactions;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 2,
                  child: const Text('Income'),
                  onTap: () {
                    setState(() {
                      foundTransactions = TransactionDB
                          .instance.incomeTransactionNotifier.value;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 3,
                  child: const Text('Expense'),
                  onTap: () {
                    setState(() {
                      foundTransactions = TransactionDB
                          .instance.expenseTransactionNotifier.value;
                    });
                  },
                ),
              ],
              onChanged: ((value) {
                _value4 = value!;
              }),
            ),
            trailing: DropdownButton(
              value: _value2,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: const Text('All'),
                  onTap: () {
                    setState(() {
                      _value4 = 1;
                      foundTransactions = transactions;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 2,
                  child: const Text('Today'),
                  onTap: () {
                    setState(() {
                      _value4 = 1;
                      foundTransactions =
                          TransactionDB.instance.todayTransactionNotifier.value;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 3,
                  child: const Text(
                    'Monthly',
                  ),
                  onTap: () {
                    _value4 = 1;

                    foundTransactions =
                        TransactionDB.instance.monthlyTransactionNotifier.value;
                  },
                ),
                DropdownMenuItem(
                  value: 4,
                  child: const Text('Custom'),
                  onTap: () {
                    _value4 = 1;
                    pickDateRange();
                  },
                ),
              ],
              onChanged: ((value) {
                setState(() {
                  _value2 = value!;
                });
              }),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      onChanged: ((value) => runFilter(value)),
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
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable:
                        TransactionDB.instance.transactionListNotifier,
                    builder: (BuildContext context,
                        List<TransactionModel> newList, _) {
                      return ListView.separated(
                        itemBuilder: ((context, index) {
                          final transactionList = foundTransactions[index];
                          return Slidable(
                            key: Key(transactionList.id!),
                            startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      setState(() {
                                        TransactionDB.instance
                                            .deleteTransaction(
                                                transactionList.id!);
                                      });
                                    },
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    label: "Delete",
                                  ),
                                ]),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return SimpleDialog(
                                        contentPadding:
                                            const EdgeInsets.all(18),
                                        title: const Text('Details'),
                                        children: [
                                          Text(
                                              'Category : ${transactionList.category.name}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Amount   : ${transactionList.amount}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Date         : ${parseDate(transactionList.date)}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Notes       : ${transactionList.notes}'),
                                        ]);
                                  }),
                                );
                              },
                              title: Text(transactionList.category.name),
                              subtitle: Text(
                                parseDate(transactionList.date),
                              ),
                              trailing: transactionList.type ==
                                      CategoryType.income
                                  ? Text(
                                      '₹${transactionList.amount.toString()}',
                                      style:
                                          const TextStyle(color: Colors.green),
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
                        itemCount: foundTransactions.length,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2023),
    );
    return newDateRange;
  }

  Future checkCustomDate() async {
    for (var i = 0; i < transactions.length; i++) {
      if (transactions[i].date == pickDateRange()) {
        foundTransactions = transactions;
      }
    }
    return foundTransactions;
  }
}

String parseDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
