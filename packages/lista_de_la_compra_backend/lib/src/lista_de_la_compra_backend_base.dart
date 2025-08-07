typedef VoidCallback = void Function();

abstract class VoidEventSource {

  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const VoidEventSource();

  /// Register a closure to be called when the object notifies its listeners.
  void addListener(VoidCallback listener);

  /// Remove a previously registered closure from the list of closures that the
  /// object notifies.
  void removeListener(VoidCallback listener);

  void notifyListeners();
}

mixin class VoidEventSourceMixin implements VoidEventSource {

  final _growableList = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    _growableList.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _growableList.remove(listener);
  }

  @override
  void notifyListeners(){
    _growableList.forEach( (listener)=> listener() );
  }
}


