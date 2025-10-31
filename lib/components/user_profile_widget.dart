import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final bool isGuestMode;
  final String? userRole;
  final String greetingText;
  final VoidCallback? onFullscreenTapped;

  const UserProfileWidget({
    super.key,
    required this.isGuestMode,
    this.userRole,
    required this.greetingText,
    this.onFullscreenTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isGuestMode
                ? Colors.grey.shade600
                : (userRole == 'korporasi' ? Colors.orange : Colors.blue),
            child: Icon(
              isGuestMode
                  ? Icons.person_outline
                  : (userRole == 'korporasi' ? Icons.business : Icons.person),
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo,',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  greetingText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onFullscreenTapped != null)
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: onFullscreenTapped,
              color: Colors.grey.shade400,
              iconSize: 32,
            ),
        ],
      ),
    );
  }
}