import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';

class AllIncomeChart extends StatefulWidget {
  const AllIncomeChart({super.key});

  @override
  State<AllIncomeChart> createState() => _AllIncomeChartState();
}

class _AllIncomeChartState extends State<AllIncomeChart> {
  List<TransactionModel> incomeTransactions =
      TransactionDB.instance.allMonthlyincomeTransactions.value;

  List<TransactionModel> temp = [];

  @override
  void initState() {
    temp = incomeTransactions;
    super.initState();
  }

  int value1 = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton(
          elevation: 1,
          dropdownColor: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(18),
          underline: Container(),
          value: value1,
          items: [
            DropdownMenuItem(
              value: 0,
              onTap: () {
                setState(() {
                  temp = incomeTransactions;
                });
              },
              child: const Text(
                'Monthly Income',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            DropdownMenuItem(
              value: 1,
              onTap: () {
                setState(() {
                  temp = TransactionDB.instance.incomeTransactionNotifier.value;
                });
              },
              child: const Text(
                'Annual Income',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
          ],
          onChanged: (value) {
            value1 = value!;
          },
        ),
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 6,
                  offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 40.0,
          ),
          margin: const EdgeInsets.all(12.0),
          child: temp.length < 2
              ? const Center(
                  child: Text(
                    'No data to render the chart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < temp.length; i++)
                            FlSpot(
                              value1 == 0
                                  ? temp[i].date.day.toDouble()
                                  : temp[i].date.month.toDouble(),
                              temp[i].amount,
                            ),
                        ],
                        isCurved: false,
                        barWidth: 2.5,
                        color: const Color(0xFF15485D),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
