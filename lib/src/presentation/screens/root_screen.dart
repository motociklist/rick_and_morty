import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../controllers/theme_mode_controller.dart';
import 'character_details_screen.dart';
import 'characters_screen.dart';
import 'favorites_screen.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  int _index = 0;
  CharacterModel? _selectedCharacter;

  static const _titles = ['PORTAL VIEW', 'PORTAL COLLECTION'];

  @override
  Widget build(BuildContext context) {
    final bool isDetailsOpen = _selectedCharacter != null;
    final themeMode = ref.watch(themeModeProvider);

    final pages = [
      CharactersScreen(
        onOpenCharacter: (character) =>
            setState(() => _selectedCharacter = character),
      ),
      FavoritesScreen(
        onOpenCharacter: (character) =>
            setState(() => _selectedCharacter = character),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: isDetailsOpen
            ? IconButton(
                onPressed: () => setState(() => _selectedCharacter = null),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              )
            : null,
        title: Text(isDetailsOpen ? 'ENTITY DOSSIER' : _titles[_index]),
        actions: [
          PopupMenuButton<ThemeMode>(
            initialValue: themeMode,
            tooltip: 'Theme',
            onSelected: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text('Theme: System'),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Theme: Light'),
              ),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Theme: Dark')),
            ],
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _PortalBackground(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: isDetailsOpen
                ? CharacterDetailsScreen(character: _selectedCharacter!)
                : IndexedStack(
                    key: ValueKey(_index),
                    index: _index,
                    children: pages,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
            _selectedCharacter = null;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'All Entities',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class _PortalBackground extends StatelessWidget {
  const _PortalBackground();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(color: colors.surface),
        CustomPaint(
          size: Size.infinite,
          painter: _GridPainter(
            dotColor: colors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        Positioned(
          top: -120,
          right: -40,
          child: _GlowOrb(
            color: colors.primary.withValues(alpha: 0.22),
            size: 280,
          ),
        ),
        Positioned(
          bottom: -140,
          left: -30,
          child: _GlowOrb(
            color: colors.secondary.withValues(alpha: 0.2),
            size: 260,
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 45)],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.dotColor});

  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    const step = 18.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor;
}
