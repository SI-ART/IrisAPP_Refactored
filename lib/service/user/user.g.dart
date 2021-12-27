part of 'user.dart';

mixin _$UserData on UserData, Store {
  final _$userModel = Atom(name: 'UserData.userModel');

  @override
  UserModel get _userStream {
    _$userModel.reportRead();
    return super._userStream;
  }

  @override
  set _userStream(UserModel value) {
    _$userModel.reportWrite(value, super._userStream, () {
      super._userStream = value;
    });
  }

  // ignore: non_constant_identifier_names
  final _$_dataActionController = ActionController(name: 'UserData');

  @override
  void updateUserInfo(UserModel data) {
    final _$actionInfo =
        _$_dataActionController.startAction(name: 'UserData.onStatusUpdate');
    try {
      return super.updateUserInfo(data);
    } finally {
      _$_dataActionController.endAction(_$actionInfo);
    }
  }
}
