import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTransaction;

  const TransactionItem({
    @required this.transaction,
    @required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 36,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        // When we have more width, I want to show a button with a text
        // next to it.
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: () => deleteTransaction(transaction.id),
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
              )
            : IconButton(
                onPressed: () => deleteTransaction(transaction.id),
                icon: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
