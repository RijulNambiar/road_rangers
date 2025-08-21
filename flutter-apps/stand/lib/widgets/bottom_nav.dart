import 'package:flutter/material.dart';
import '../screens/map_screen.dart';
import '../screens/sos_screen.dart';
import '../screens/assist_screen.dart';
import '../screens/profile_screen.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Increased height to accommodate content
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, 0, Icons.map_outlined, Icons.map, 'Map'),
            _buildNavItem(context, 1, Icons.warning_outlined, Icons.warning, 'SOS'),
            _buildNavItem(context, 2, Icons.help_outline, Icons.help, 'Assist'),
            _buildNavItem(context, 3, Icons.person_outline, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData outlinedIcon,
      IconData filledIcon, String label) {
    final bool isSelected = _getCurrentIndex(context) == index;
    final Color primaryColor = const Color(0xFF2196F3);
    final Color inactiveColor = Colors.grey[600]!;

    return SizedBox(
      width: 80,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(context, index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    key: ValueKey(isSelected),
                    color: isSelected ? primaryColor : inactiveColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? primaryColor : inactiveColor,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    if (currentRoute.contains('sos')) return 1;
    if (currentRoute.contains('assist')) return 2;
    if (currentRoute.contains('profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (_getCurrentIndex(context) == index) return;

    final screens = [
      const MapScreen(),
      SOSScreen(),
      AssistScreen(),
      ProfileScreen(),
    ];

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screens[index],
        settings: RouteSettings(
          name: ['/', '/sos', '/assist', '/profile'][index],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}