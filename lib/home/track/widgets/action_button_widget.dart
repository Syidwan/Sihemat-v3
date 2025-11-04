import 'package:flutter/material.dart';

/// Widget reusable untuk action button dengan style sama seperti MenuGrid
class ActionButton extends StatefulWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final double fontSize;
  final double borderRadius;

  const ActionButton({
    Key? key,
    this.icon,
    this.assetPath,
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 72,
    this.iconSize = 32,
    this.fontSize = 12,
    this.borderRadius = 24,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       ),
       super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isPressed ? Colors.grey.shade200 : widget.color,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _isPressed ? Colors.grey.shade200 : Colors.grey.shade400,
                width: _isPressed ? 3 : 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildIcon(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    // Prioritas: assetPath > icon
    if (widget.assetPath != null) {
      return Image.asset(
        widget.assetPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback ke icon jika asset tidak ditemukan
          debugPrint('Error loading asset: ${widget.assetPath}');
          return Icon(
            widget.icon ?? Icons.error_outline,
            size: widget.iconSize,
            color: _isPressed ? Colors.grey.shade600 : widget.color,
          );
        },
      );
    }

    // Gunakan icon jika tidak ada assetPath
    return Icon(
      widget.icon ?? Icons.help_outline,
      size: widget.iconSize,
      color: _isPressed ? Colors.grey.shade600 : widget.color,
    );
  }
}

/// Variant dengan style outline
class ActionButtonOutline extends StatefulWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final double fontSize;
  final double borderRadius;

  const ActionButtonOutline({
    Key? key,
    this.icon,
    this.assetPath,
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 72,
    this.iconSize = 32,
    this.fontSize = 12,
    this.borderRadius = 24,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       ),
       super(key: key);

  @override
  State<ActionButtonOutline> createState() => _ActionButtonOutlineState();
}

class _ActionButtonOutlineState extends State<ActionButtonOutline> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isPressed ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _isPressed
                    ? widget.color.withOpacity(0.5)
                    : widget.color,
                width: _isPressed ? 3 : 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _buildIcon(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.assetPath != null) {
      return Image.asset(
        widget.assetPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading asset: ${widget.assetPath}');
          return Icon(
            widget.icon ?? Icons.error_outline,
            size: widget.iconSize,
            color: widget.color,
          );
        },
      );
    }

    return Icon(
      widget.icon ?? Icons.help_outline,
      size: widget.iconSize,
      color: widget.color,
    );
  }
}

/// Variant compact untuk space terbatas (seperti di bottom sheet)
class ActionButtonCompact extends StatefulWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionButtonCompact({
    Key? key,
    this.icon,
    this.assetPath,
    required this.label,
    required this.color,
    required this.onTap,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       ),
       super(key: key);

  @override
  State<ActionButtonCompact> createState() => _ActionButtonCompactState();
}

class _ActionButtonCompactState extends State<ActionButtonCompact> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _isPressed ? Colors.grey.shade200 : widget.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isPressed ? Colors.white : Colors.white,
                width: _isPressed ? 2.5 : 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: _buildIcon(),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.assetPath != null) {
      return Image.asset(
        widget.assetPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading asset: ${widget.assetPath}');
          return Icon(
            widget.icon ?? Icons.error_outline,
            size: 24,
            color: _isPressed ? Colors.grey.shade600 : widget.color,
          );
        },
      );
    }

    return Icon(
      widget.icon ?? Icons.help_outline,
      size: 24,
      color: _isPressed ? Colors.grey.shade600 : widget.color,
    );
  }
}
