import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 16),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];
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
                          icon: Icon(Icons.delete_rounded),
                          label: Text('Delete'),
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
            },
          );
  }
}
