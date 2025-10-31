import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/menu_item.dart';

class MenuGridWidget extends StatefulWidget {
  final List<MenuItem> menuItems;
  final Function(String menuId) onMenuTapped;

  const MenuGridWidget({
    super.key,
    required this.menuItems,
    required this.onMenuTapped,
  });

  @override
  State<MenuGridWidget> createState() => _MenuGridWidgetState();
}

class _MenuGridWidgetState extends State<MenuGridWidget> {
  int? _selectedMenuIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: widget.menuItems.length,
      itemBuilder: (context, index) {
        final item = widget.menuItems[index];
        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              _selectedMenuIndex = index;
            });
          },
          onTapUp: (_) {
            setState(() {
              _selectedMenuIndex = null;
            });
            widget.onMenuTapped(item.id);
          },
          onTapCancel: () {
            setState(() {
              _selectedMenuIndex = null;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _selectedMenuIndex == index
                      ? Colors.grey.shade200
                      : item.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _selectedMenuIndex == index
                        ? Colors.grey.shade200
                        : Colors.grey.shade400,
                    width: _selectedMenuIndex == index ? 3 : 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: item.assetPath != null
                      ? Image.asset(
                          item.assetPath!,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          item.icon,
                          size: 32,
                          color: item.color,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}