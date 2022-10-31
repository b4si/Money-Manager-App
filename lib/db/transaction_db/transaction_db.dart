// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/screens/transaction_screen/transaction_screen.dart';
import 'package:money_manager/transaction_model/transaction_model.dart';

import '../../catagory_model/category_model.dart';

const transactionDbName = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String transactionID);
  Future<void> deleteAllTransactions();
  // Future<void> editTarsaction(index,String transactionID);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> incomeTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> todayTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyTransactionNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> tempNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    _db.put(obj.id, obj);
    refresh();
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();

    transactionListNotifier.value.clear();
    incomeTransactionNotifier.value.clear();
    expenseTransactionNotifier.value.clear();
    tempNotifier.value.clear();

    _list.sort((first, second) => second.date.compareTo(first.date));

    transactionListNotifier.value.addAll(_list);

    transactionListNotifier.notifyListeners();

    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.type == CategoryType.income) {
          incomeTransactionNotifier.value.add(transaction);
        } else {
          expenseTransactionNotifier.value.add(transaction);
        }
      },
    );
    incomeTransactionNotifier.notifyListeners();
    expenseTransactionNotifier.notifyListeners();

    todayTransactionNotifier.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
          todayTransactionNotifier.value.add(transaction);
        } else {
          return;
        }
      },
    );

    todayTransactionNotifier.notifyListeners();

    monthlyTransactionNotifier.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date == DateTime(DateTime.daysPerWeek)) {
          monthlyTransactionNotifier.value.add(transaction);
        }
      },
    );
    monthlyTransactionNotifier.notifyListeners();
  }

  double totalAmount() {
    double totalAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      totalAmount = (allIncomeAmount() - allExpenseAmount());
      refresh();
    }

    return totalAmount;
  }

  double allIncomeAmount() {
    double totalIncomeAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      if (transactionListNotifier.value[i].category.type ==
          CategoryType.income) {
        totalIncomeAmount =
            totalIncomeAmount + transactionListNotifier.value[i].amount;
        refresh();
      }
    }
    return totalIncomeAmount;
  }

  double allExpenseAmount() {
    double totalExpenseAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      if (transactionListNotifier.value[i].category.type ==
          CategoryType.expense) {
        totalExpenseAmount =
            totalExpenseAmount + transactionListNotifier.value[i].amount;
        refresh();
      }
    }
    return totalExpenseAmount;
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String transactionID) async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    await _db.delete(transactionID);
    refresh();
  }

  @override
  Future<void> deleteAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    _db.clear();
    refresh();
  }
}
