import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';

import '../../transaction_model/transaction_model.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  List<String> items = [
    'Income',
    'Expense',
  ];
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          borderRadius: BorderRadius.circular(18),
          hint: const Text(
            'Income',
            style: TextStyle(color: Colors.black),
          ),
          value: selectedItem,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (item) {
            setState(() {
              selectedItem = item;
            });
          },
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: TransactionDB.instance.transactionListNotifier,
            builder: (BuildContext context, List<TransactionModel> newList, _) {
              return PieChartData == 0
                  ? const Text('NO')
                  : PieChart(
                      PieChartData(
                        centerSpaceRadius: 70,
                        sectionsSpace: 5,
                        sections: [
                          PieChartSectionData(
                            title: newList[0].category.name,
                            color: Colors.amber,
                            value: newList[0].amount,
                            radius: 40,
                          ),
                          PieChartSectionData(
                              title: newList[1].category.name,
                              color: Colors.green,
                              value: newList[1].amount),
                          PieChartSectionData(
                              title: newList[2].category.name,
                              color: Colors.red,
                              value: newList[2].amount),
                          PieChartSectionData(
                              title: newList[4].category.name,
                              color: Colors.blue,
                              value: newList[4].amount),
                        ],
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
