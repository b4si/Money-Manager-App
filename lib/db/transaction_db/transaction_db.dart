// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/transaction_model/transaction_model.dart';

import '../../catagory_model/category_model.dart';

const transactionDbName = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String transactionID);
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

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    _db.put(obj.id, obj);
    refresh();
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();

    transactionListNotifier.value.addAll(_list);

    transactionListNotifier.notifyListeners();
  }

  double totalAmount() {
    double totalAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      totalAmount = (allIncomeAmount() - allExpenseAmount());
    }
    refresh();
    return totalAmount;
  }

  double allIncomeAmount() {
    double totalIncomeAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      if (transactionListNotifier.value[i].category.type ==
          CategoryType.income) {
        totalIncomeAmount =
            totalIncomeAmount + transactionListNotifier.value[i].amount;
      }
      refresh();
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
      }
      refresh();
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
}
