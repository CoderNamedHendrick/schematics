# Schematics 📐

A customisable and responsive Flutter widget for creating and displaying schematic diagrams.

[![pub package](https://img.shields.io/pub/v/schematics.svg?label=Version&style=flat)][pub]
[![Stars](https://img.shields.io/github/stars/codernamedhendrick/schematics?label=Stars&style=flat)][repo]
[![Watchers](https://img.shields.io/github/watchers/codernamedhendrick/schematics?label=Watchers&style=flat)][repo]

[![GitHub issues](https://img.shields.io/github/issues/codernamedhendrick/schematics?label=Issues&style=flat)][issues]
[![GitHub License](https://img.shields.io/github/license/codernamedhendrick/schematics?label=Licence&style=flat)][license]

## Table of Content

- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [License](#license)
- [Screenshots](#screenshots-)

## Features

- `2D schematic map/diagram`: Allows you to create and display 2D diagrams, maps, and floor plans.
  Entrances and openings: You can add entrances and openings to your diagrams, which can be either
  line openings or arc openings.
- `2D grid map`: Provides a grid where the schematic is drawn, specifying the areas that are the
  blocks on the diagram.
- `Line openings`: Simple straight-line openings that can be added to blocks.
- `Arc openings`: Curved openings that can be semicircles, sectors, or quarter circles.

## Usage

To use the `Schema` widget for creating and displaying schematic diagrams, you need to understand
the following
concepts:

1. **Schema**: The `Schema` widget serves as the base for all blocks used in the schematics. It
   takes a `config` parameter, which is a `SchemaConfiguration` object.

2. **Schema Configuration**: The `SchemaConfiguration` object includes properties such as size, axis
   scale initialization, and other configurations.

3. **Blocks**: The `Schema` widget takes a list of `Block` objects. Each `Block` has properties like
   height, width, border, fence border, label, label style, position, and stroke width.

4. **Block Layout**: The `Schema` widget also takes an `onBlockLayout` callback, which returns a
   list of `BlockArea` objects representing all the block areas in the schema.

5. **Grid Update**: The `Schema` widget also takes `onGridUpdate` callback returns the updated grid,
   highlighting different positions on it.

6. **onBlockAreaTap**: The `Schema` widget `onBlockAreaTap` callback returns the tapped block area
   and local and global positions of the tap.

### Example

```dart
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Schematics Example')),
        body: Schema(
          config: SchemaConfiguration(
            size: SchemaSize(cell: kDefaultSchemaSize.cell, opening: 25),
            initiateAxesScale: (constraints) =>
                AxesScale(
                  x: 1,
                  y: 1,
                  opening: 1,
                ),
            // other properties
          ),
          blocks: [
            Block(
              height: 100,
              width: 100,
              border: Border.all(color: Colors.black),
              fenceBorder: FenceBorder.all,
              label: 'Block 1',
              labelStyle: TextStyle(color: Colors.black),
              position: Offset(50, 50),
              strokeWidth: 2.0,
            ),
            // other blocks
          ],
          onBlockLayout: (blocks) {
            // Perform operation with blocks
          },
          onGridUpdate: (grid) {
            // handle grid update
          },
          onBlockAreaTap: (blockArea, globalPosition) {
            // handle block area tap
          },
        ),
      ),
    );
  }
}
```

Refer to example project [here](https://github.com/CoderNamedHendrick/schematics/tree/main/example).

> [!NOTE]
> For more real-world example, check-out the 2024 Lagos Devfest
> application [here](https://github.com/GDG-W/cave/blob/dev/packages/conferenceapp/lib/src/features/more/presentation/screens/venue_map.dart)

## Installation

Add `schematics` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  schematics: ^latest_version
```

Then run `flutter pub get` to fetch the package.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Screenshots 📱

![desktop screenshot/record of schematics](screenshots/desktop_view.gif)
![mobile screenshot/record of schematics](screenshots/mobile_view.gif)

## 🤓 Developer(s)

[<img src="https://github.com/CoderNamedHendrick.png" width="180" />](https://github.com/CoderNamedHendrick)

#### **Sebastine Odeh**

[![GitHub: codernamedhendrick](https://img.shields.io/badge/codernamedhendrick-EFF7F6?logo=GitHub&logoColor=333&link=https://www.github.com/codernamedhendrick)][github]
[![Linkedin: SebastineOdeh](https://img.shields.io/badge/SebastineOdeh-EFF7F6?logo=LinkedIn&logoColor=blue&link=https://www.linkedin.com/in/sebastine-odeh-1081a318b/)][linkedin]
[![Twitter: h3ndrick_](https://img.shields.io/badge/h3ndrick__-EFF7F6?logo=X&logoColor=333&link=https://x.com/H3ndrick_)][twitter]
[![Gmail: sebastinesoacatp@gmail.com](https://img.shields.io/badge/sebastinesoacatp@gmail.com-EFF7F6?logo=Gmail&link=mailto:sebastinesoacatp@gmail.com)][gmail]

[pub]: https://pub.dev/packages/schematics

[repo]: https://github.com/CoderNamedHendrick/schematics

[issues]: https://github.com/CoderNamedHendrick/schematics/issues

[license]: https://github.com/CoderNamedHendrick/schematics/blob/main/LICENSE

[github]: https://www.github.com/codernamedhendrick

[linkedin]: https://www.linkedin.com/in/sebastine-odeh-1081a318b

[twitter]: https://x.com/H3ndrick_

[gmail]: mailto:sebastinesoacatp@gmail.com
