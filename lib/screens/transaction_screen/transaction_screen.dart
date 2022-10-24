// ignore_for_file: unused_local_variable, override_on_non_overriding_member, unused_field

import 'package:flutter/material.dart';
import 'package:money_manager/screens/transaction_screen/list_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  final TextEditingController _searchController = TextEditingController();
  String? selectedItem;
  int? _value1;
  int _value2 = 1;

  List<String> items = [
    'All',
    'Income',
    'Expense',
  ];

  @override

  // var tempTransactionList;

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
              hint: const Text(
                'All',
                style: TextStyle(color: Colors.black),
              ),
              value: selectedItem,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: ((item) {
                setState(() {
                  selectedItem = item;
                  // _value1 = selectedItem;
                });
              }),
            ),
            trailing: DropdownButton(
              value: _value2,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Monthly'),
                ),
              ],
              onChanged: ((value) {
                setState(() {
                  _value2 = value!;
                });
              }),
            ),
          ),
          const Expanded(
            child: ListWidget(),
          ),
        ],
      ),
    );
  }
}
