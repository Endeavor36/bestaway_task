import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';
import '../providers/auth_provider.dart';
import '../widgets/quote_builder.dart';
import '../providers/quote_provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  _signOut(BuildContext context) {
    context.read<AuthProvider>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('You will be logged out!'),
                  actions: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        _signOut(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: context.read<QuoteProvider>().getQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching quotes!'),
              );
            } else if (snapshot.hasData) {
              var quotes = snapshot.data as List<Quote>;
              return QuoteBuilder(quotes: quotes);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
