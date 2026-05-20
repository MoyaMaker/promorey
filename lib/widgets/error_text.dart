import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? error;
  const ErrorText({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        error!,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
