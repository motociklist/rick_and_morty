import 'package:flutter/material.dart';

import '../../data/models/character_model.dart';

class CharacterDetailsScreen extends StatelessWidget {
  const CharacterDetailsScreen({super.key, required this.character});

  final CharacterModel character;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _AvatarPanel(character: character),
        const SizedBox(height: 14),
        Text(
          character.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            height: 0.95,
            fontWeight: FontWeight.w900,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${character.species.toUpperCase()} • ${character.gender.toUpperCase()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.3,
            color: colors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _TechInfoTile(
          title: 'ID',
          value: '${character.id}',
          valueColor: colors.primary,
        ),
        _TechInfoTile(
          title: 'STATUS',
          value: character.status.toUpperCase(),
          valueColor: _statusColor(character.status, colors),
        ),
        _TechInfoTile(
          title: 'SPECIES',
          value: character.species.toUpperCase(),
          valueColor: colors.secondary,
        ),
        _TechInfoTile(
          title: 'GENDER',
          value: character.gender.toUpperCase(),
          valueColor: colors.tertiary,
        ),
        _TechInfoTile(
          title: 'ORIGIN',
          value: character.originName,
          valueColor: colors.primary,
        ),
        _TechInfoTile(
          title: 'LAST LOCATION',
          value: character.locationName,
          valueColor: colors.secondary,
        ),
        _TechInfoTile(
          title: 'EPISODES',
          value: '${character.episodeCount}',
          valueColor: colors.primary,
        ),
        if (character.type.isNotEmpty)
          _TechInfoTile(
            title: 'TYPE',
            value: character.type,
            valueColor: colors.tertiary,
          ),
      ],
    );
  }
}

class _AvatarPanel extends StatelessWidget {
  const _AvatarPanel({required this.character});

  final CharacterModel character;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.primary.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.28),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(character.image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'ID: ${character.id}',
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _TechInfoTile extends StatelessWidget {
  const _TechInfoTile({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status, ColorScheme colors) {
  switch (status.toLowerCase()) {
    case 'alive':
      return colors.primary;
    case 'dead':
      return colors.error;
    default:
      return colors.secondary;
  }
}
