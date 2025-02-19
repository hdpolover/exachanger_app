// "data": [
//             {
//                 "id": "e099d390-6593-46ae-a2b5-6bdebd430598",
//                 "slug": "testing-article",
//                 "title": "Testing Article",
//                 "featured_image": "http://localhost:3000/files/images/files/images/20250103133119_EDITED-49.jpg",
//                 "excerpt": "<p>Testing article synopsis</p>",
//                 "content": "<p>Testing article content</p>",
//                 "category": "blog",
//                 "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
//                 "created_at": "2025-01-06T16:26:59.000Z",
//                 "updated_at": null,
//                 "deleted_at": null
//             }
//         ],
//         "meta": {
//             "pagination": {
//                 "current_page": 1,
//                 "last_page": 10,
//                 "from": 1,
//                 "to": 1,
//                 "page": 1,
//                 "offset": 1,
//                 "limit": 1,
//                 "total": "10"
//             }
//         }

class PaginationResponseModel<T> {
  final List<T>? data;
  final MetaModel? meta;

  PaginationResponseModel({
    this.data,
    this.meta,
  });

  factory PaginationResponseModel.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PaginationResponseModel<T>(
      data: json['data'] != null
          ? (json['data'] as List).map((e) => fromJsonT(e)).toList()
          : null,
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
    );
  }

  @override
  String toString() => 'PaginationResponseModel{data: $data, meta: $meta}';
}

class MetaModel {
  final PaginationModel? pagination;

  MetaModel({
    this.pagination,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }

  @override
  String toString() => 'MetaModel{pagination: $pagination}';
}

class PaginationModel {
  final int? currentPage;
  final int? lastPage;
  final int? from;
  final int? to;
  final int? page;
  final int? offset;
  final int? limit;
  final int? total;

  PaginationModel({
    this.currentPage,
    this.lastPage,
    this.from,
    this.to,
    this.page,
    this.offset,
    this.limit,
    this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      from: json['from'],
      to: json['to'],
      page: json['page'],
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
    );
  }

  @override
  String toString() =>
      'PaginationModel{currentPage: $currentPage, lastPage: $lastPage, from: $from, to: $to, page: $page, offset: $offset, limit: $limit, total: $total}';
}
