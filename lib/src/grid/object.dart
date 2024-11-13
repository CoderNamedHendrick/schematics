import 'package:flutter/foundation.dart';

import 'cell.dart';

class Grid<T extends Object> {
  final List<List<T>> grid;

  final T initialValue;

  const Grid._(this.grid, this.initialValue);

  factory Grid.make(int rows, int columns, T initialValue) {
    return Grid._(
      List.generate(
        rows,
        (index) => List.generate(columns, (index) => initialValue),
      ),
      initialValue,
    );
  }

  ({int rows, int columns}) get size {
    return (rows: rows, columns: columns);
  }

  int get rows {
    return grid.length;
  }

  int get columns {
    return grid.first.length;
  }

  int filledCellsCount(bool Function(T state) filter) {
    return filledCells(filter).length;
  }

  List<GridCell> filledCells(bool Function(T state) filter) {
    List<GridCell> cells = [];
    for (int i = 0; i <= rows - 1; i++) {
      for (int j = 0; j <= columns - 1; j++) {
        final state = grid[i][j];

        if (filter(state)) cells.add(GridCell(row: i, column: j));
      }
    }
    return cells;
  }

  void resetCells(List<GridCell> cells) {
    for (final cell in cells) {
      grid[cell.row][cell.column] = initialValue;
    }
  }

  void fillCells(List<GridCell> cells, T state) {
    for (final cell in cells) {
      grid[cell.row][cell.column] = state;
    }
  }

  bool filter(GridCell cell, bool Function(T state) filter) {
    return filter(grid[cell.row][cell.column]);
  }

  bool filterCells(List<GridCell> cells, bool Function(T state) filter) {
    for (final cell in cells) {
      if (!filter(grid[cell.row][cell.column])) return false;
    }
    return true;
  }

  GridCell? firstWhereOrNull(bool Function(T state) predicate) {
    for (int i = 0; i <= rows - 1; i++) {
      for (int j = 0; j <= columns - 1; j++) {
        final state = grid[i][j];

        if (predicate(state)) return GridCell(row: i, column: j);
      }
    }
    return null;
  }

  Map<String, GridCell?> getNeighbourPositions(GridCell cell) {
    final neighbours = <String, GridCell?>{};

    if (validPosition(cell.above)) {
      neighbours['above'] = cell.above;
    } else {
      neighbours['above'] = null;
    }

    if (validPosition(cell.below)) {
      neighbours['below'] = cell.below;
    } else {
      neighbours['below'] = null;
    }

    if (validPosition(cell.left)) {
      neighbours['left'] = cell.left;
    } else {
      neighbours['left'] = null;
    }

    if (validPosition(cell.right)) {
      neighbours['right'] = cell.right;
    } else {
      neighbours['right'] = null;
    }

    return neighbours;
  }

  bool validPosition(GridCell cell) {
    return cell.row >= 0 &&
        cell.row < rows &&
        cell.column >= 0 &&
        cell.column < columns;
  }

  /// Due to the vector nature of the grid(2x2 matrix), to ensure the equality
  /// works properly and to help dart infer that a new grid object is created
  /// we use the grid factory to create a new instance and copy the grid values
  /// to this new grid before returning the instance
  Grid<T> copyWith({List<List<T>>? grid}) {
    if (grid != null) {
      Grid<T> nextGrid = Grid.make(rows, columns, initialValue);

      for (int i = 0; i <= rows - 1; i++) {
        for (int j = 0; j <= columns - 1; j++) {
          // try block to silent fuzzy errors that come from resizing the
          // window
          try {
            nextGrid.grid[i][j] = grid[i][j];
          } catch (_) {}
        }
      }

      return nextGrid;
    }

    return Grid._(grid ?? this.grid, initialValue);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grid<T> && listEquals(other.grid, grid);
  }

  @override
  int get hashCode => grid.hashCode;
}
