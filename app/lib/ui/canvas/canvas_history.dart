class CanvasHistory<T> {
  final List<T> _undo = [];
  final List<T> _redo = [];

  void push(T state) {
    _undo.add(state);
    _redo.clear();
  }

  T? undo(T current) {
    if (_undo.isEmpty) return null;
    _redo.add(current);
    return _undo.removeLast();
  }

  T? redo(T current) {
    if (_redo.isEmpty) return null;
    _undo.add(current);
    return _redo.removeLast();
  }
}
