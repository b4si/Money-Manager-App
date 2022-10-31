// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import '../../catagory_model/category_model.dart';
// import '../../db/transaction_db/transaction_db.dart';
// import '../../transaction_model/transaction_model.dart';
// import '../form_screen/form_screen.dart';

// class ListShowBody extends StatefulWidget {
//   const ListShowBody({super.key});

//   @override
//   State<ListShowBody> createState() => _ListShowStateBody();
// }

// class _ListShowStateBody extends State<ListShowBody> {
//   List<TransactionModel> transactions =
//       TransactionDB.instance.transactionListNotifier.value;

//   List<TransactionModel> foundTransactions = [];

//   @override
//   void initState() {
//     foundTransactions = transactions;

//     super.initState();
//   }

//   void runFilter(String enteredKeyword) {
//     List<TransactionModel> results = [];
//     if (enteredKeyword.isEmpty) {
//       results = transactions;
//     } else {
//       results = transactions
//           .where(
//             (user) => user.category.name.trim().toLowerCase().contains(
//                   enteredKeyword.trim().toLowerCase(),
//                 ),
//           )
//           .toList();
//     }
//     setState(() {
//       foundTransactions = results;
//     });
//   }

//   void allDAte() {
//     setState(() {
//       foundTransactions;
//     });
//   }

//   void todaysdate(DateTime selecteddate) {
//     List<TransactionModel> results = [];
//     if (selecteddate == DateTime.now()) {
//       results = transactions;
//     }
//     setState(() {
//       foundTransactions = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: SizedBox(
//             height: 50,
//             child: TextFormField(
//               onChanged: ((value) => runFilter(value)),
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 suffixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ValueListenableBuilder(
//             valueListenable: TransactionDB.instance.transactionListNotifier,
//             builder: (BuildContext context, List<TransactionModel> newList, _) {
//               return ListView.separated(
//                 itemBuilder: ((context, index) {
//                   final transactionList = foundTransactions[index];
//                   return Slidable(
//                     key: Key(transactionList.id!),
//                     startActionPane:
//                         ActionPane(motion: const StretchMotion(), children: [
//                       SlidableAction(
//                         onPressed: (ctx) {
//                           setState(() {
//                             TransactionDB.instance
//                                 .deleteTransaction(transactionList.id!);
//                           });
//                         },
//                         backgroundColor: Colors.red,
//                         icon: Icons.delete,
//                         label: "Delete",
//                       ),
//                     ]),
//                     child: ListTile(
//                       onTap: () {
//                         showDialog(
//                             context: context,
//                             builder: ((context) {
//                               return SimpleDialog(
//                                   contentPadding: const EdgeInsets.all(18),
//                                   title: const Text('Details'),
//                                   children: [
//                                     Text(
//                                         'Category : ${transactionList.category.name}'),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                         'Amount   : ${transactionList.amount}'),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                         'Date         : ${parseDate(transactionList.date)}'),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                         'Notes       : ${transactionList.notes}'),
//                                   ]);
//                             }));
//                       },
//                       title: Text(transactionList.category.name),
//                       subtitle: Text(
//                         parseDate(transactionList.date),
//                       ),
//                       trailing: transactionList.type == CategoryType.income
//                           ? Text(
//                               '₹${transactionList.amount.toString()}',
//                               style: const TextStyle(color: Colors.green),
//                             )
//                           : Text(
//                               '₹${transactionList.amount.toString()}',
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                     ),
//                   );
//                 }),
//                 separatorBuilder: (context, index) {
//                   return const Padding(
//                     padding: EdgeInsets.only(right: 15, left: 15),
//                     child: Divider(
//                       thickness: 1,
//                       color: Colors.grey,
//                     ),
//                   );
//                 },
//                 itemCount: foundTransactions.length,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// String parseDate(DateTime date) {
//   return '${date.day}/${date.month}/${date.year}';
// }
