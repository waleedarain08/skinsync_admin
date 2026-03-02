abstract class BaseStateModel {
  bool loading;

  BaseStateModel({this.loading = false});

  void setLoading(bool value) => loading = value;
}
