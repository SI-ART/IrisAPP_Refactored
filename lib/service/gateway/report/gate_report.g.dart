part of 'gate_report.dart';

mixin _$GateReport on _GateReport, Store {
  final _$state = Atom(name: '_GateReport.state');
  final _$isProcessing = Atom(name: '_GateReport.isProcessing');

  @override
  String get state {
    _$state.reportRead();
    return super.state;
  }

  @override
  bool get isProcessing {
    _$isProcessing.reportRead();
    return super.isProcessing;
  }

  // ignore: non_constant_identifier_names
  final _$_stateActionController = ActionController(name: '_GatewayService');

  @override
  Future<void> generateNewDoc(GatewayModel gatewayModel) {
    final _$actionInfo =
        _$_stateActionController.startAction(name: '_GatewayService.setScreen');
    try {
      return super.generateNewDoc(gatewayModel);
    } finally {
      _$_stateActionController.endAction(_$actionInfo);
    }
  }
}
