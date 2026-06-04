abstract class BaseStateModel {
  final bool loading;
  final int currentPage;
  final int totalPages;
  final int totalResults;

  BaseStateModel({
    this.loading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalResults = 0,
  });
}
