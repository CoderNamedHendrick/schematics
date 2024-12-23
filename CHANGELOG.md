## 1.0.3

- internal improvements
- added onBlockTap to Schema to communicate taps on block areas, this returns
  block area tap event which includes the `BlockArea` and a global and local position.

## 1.0.2

- allow label overflow for arc entrance
- added labelMargin to withLabel extension

## 1.0.1

- update description

## 1.0.0

- Stable release
- README update
- breaking changes:
    - renamed SchemaWidget to Schema
    - renamed SchemaConfig to SchemaConfiguration

## 1.0.0-dev.1.8

- removed entranceLabel, entranceLabelStyle, entranceLabelRadius from `Block` class, use arc
  openings instead.
- introduced arc openings for blocks. They work exactly like openings
  but are arcs.
- breaking change: moved schemaSize, showGrid, showBlocks, layoutDirection and onInitiateAxes to
  SchemaConfig

## 1.0.0-dev.1.7

- more development on the API
- update README

## 1.0.0-dev.1.6

- breaking changes with API
- made some records classes instead, namely: AxesScale, SchemaSize, BlockLayoutArea etc.
- changed BlockLayoutArea to BlockArea
- change some parameter names

## 1.0.0-dev.1.5

- introduced identifier for blocks

## 1.0.0-dev.1.4

- fixed bug with entrance radius

## 1.0.0-dev.1.3

- allow entrance arc to be customisable

## 1.0.0-dev.1.2

- added documentation
- added example
- added screenshots

## 1.0.0-dev.1

- Initial release
