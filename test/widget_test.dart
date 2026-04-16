import 'package:flutter_test/flutter_test.dart';

import 'package:demo2/src/data/models/character_model.dart';

void main() {
  test('CharacterModel parses expected fields', () {
    final model = CharacterModel.fromJson({
      'id': 1,
      'name': 'Rick Sanchez',
      'status': 'Alive',
      'species': 'Human',
      'location': {'name': 'Citadel of Ricks'},
      'image': 'https://example.com/rick.png',
    });

    expect(model.id, 1);
    expect(model.name, 'Rick Sanchez');
    expect(model.status, 'Alive');
    expect(model.species, 'Human');
    expect(model.locationName, 'Citadel of Ricks');
  });
}
