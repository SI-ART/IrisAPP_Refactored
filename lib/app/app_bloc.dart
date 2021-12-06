import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends Disposable {
  final loading = BehaviorSubject<bool>.seeded(false);

  Function(bool) get setLoad => loading.sink.add;
  Stream<bool> get getLoad => loading.stream;

  @override
  void dispose() {}
}
