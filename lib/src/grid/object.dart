import 'package:flutter/foundation.dart';

import 'cell.dart';

/// A generic grid class that holds a 2D list of objects of type [T].
class Grid<T extends Object> {
  /// The 2D list representing the grid.
  final List<List<T>> grid;

  /// The initial value for the grid cells.
  final T initialValue;

  /// Private constructor for creating a grid with the given [grid] and [initialValue].
  const Grid._(this.grid, this.initialValue);

  /// Factory constructor to create a grid with the specified number of [rows] and [columns],
  /// initializing all cells with the [initialValue].
  factory Grid.make(int rows, int columns, T initialValue) {
    return Grid._(
      List.generate(
        rows,
        (index) => List.generate(columns, (index) => initialValue),
      ),
      initialValue,
    );
  }

  /// Returns the size of the grid as a map with keys `rows` and `columns`.
  ({int rows, int columns}) get size {
    return (rows: rows, columns: columns);
  }

  /// Returns the number of rows in the grid.
  int get rows {
    return grid.length;
  }

  /// Returns the number of columns in the grid.
  int get columns {
    return grid.first.length;
  }

  /// Returns the count of cells that match the given [filter] function.
  int filledCellsCount(bool Function(T state) filter) {
    return filledCells(filter).length;
  }

  /// Returns a list of [GridCell]s that match the given [filter] function.
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

  /// Resets the specified [cells] to the initial value.
  void resetCells(List<GridCell> cells) {
    for (final cell in cells) {
      grid[cell.row][cell.column] = initialValue;
    }
  }

  /// Fills the specified [cells] with the given [state].
  void fillCells(List<GridCell> cells, T state) {
    for (final cell in cells) {
      grid[cell.row][cell.column] = state;
    }
  }

  /// Applies the [filter] function to the cell at the given [cell] position.
  bool filter(GridCell cell, bool Function(T state) filter) {
    return filter(grid[cell.row][cell.column]);
  }

  /// Applies the [filter] function to all the specified [cells].
  /// Returns `true` if all cells match the filter, otherwise `false`.
  bool filterCells(List<GridCell> cells, bool Function(T state) filter) {
    for (final cell in cells) {
      if (!filter(grid[cell.row][cell.column])) return false;
    }
    return true;
  }

  /// Returns the first [GridCell] that matches the given [predicate] function, or `null` if none found.
  GridCell? firstWhereOrNull(bool Function(T state) predicate) {
    for (int i = 0; i <= rows - 1; i++) {
      for (int j = 0; j <= columns - 1; j++) {
        final state = grid[i][j];

        if (predicate(state)) return GridCell(row: i, column: j);
      }
    }
    return null;
  }

  /// Returns a map of neighboring positions for the given [cell].
  /// The keys are `above`, `below`, `left`, and `right`.
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

  /// Checks if the given [cell] position is valid within the grid boundaries.
  bool validPosition(GridCell cell) {
    return cell.row >= 0 &&
        cell.row < rows &&
        cell.column >= 0 &&
        cell.column < columns;
  }

  /// Creates a copy of the grid with the option to replace the [grid] values.
  /// If [grid] is provided, it will be used to create the new grid.
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
