import 'package:get/get.dart';

import '../../core/models/github_search_query_param.dart';
import '../models/github_project_search_response.dart';
import '/app/data/remote/github_remote_data_source.dart';
import '/app/data/repository/github_repository.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource _remoteSource =
      Get.find(tag: (GithubRemoteDataSource).toString());

  @override
  Future<GithubProjectSearchResponse> searchProject(
      GithubSearchQueryParam queryParam) {
    return _remoteSource.searchGithubProject(queryParam);
  }

  @override
  Future<Item> getProject(String userName, String repositoryName) {
    return _remoteSource.getGithubProjectDetails(userName, repositoryName);
  }
}
