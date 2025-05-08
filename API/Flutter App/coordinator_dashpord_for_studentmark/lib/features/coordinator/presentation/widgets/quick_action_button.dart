import 'package:flutter/material.dart';

import '../../../../config/constants.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Icon(
              icon,
              size: MediaQuery.of(context).size.width <=
                      AppConstants.mobileBreakpoint
                  ? 24
                  : 32,
              color: Colors.white,
            ),
          ),
          // const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width <=
                        AppConstants.mobileBreakpoint
                    ? 12
                    : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
