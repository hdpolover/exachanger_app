// {
//         "id": "820fe98d-4a0b-4975-8bfe-5789af31491a",
//         "title": "Promo Awal Tahun",
//         "image": "http://localhost:3000/files/images/files/images/20250103133119_EDITED-49.jpg",
//         "url": "http://localhost:3000",
//         "content": "<p>Testing</p>",
//         "code": "151954",
//         "start_date": "2025-01-07T07:50:25.000Z",
//         "end_date": "2025-01-12T07:50:35.000Z",
//         "quota": 100,
//         "status": 1,
//         "created_at": "2025-01-06T07:50:46.000Z",
//         "updated_at": null,
//         "deleted_at": null
//     }

class PromoModel {
  final String? id;
  final String? title;
  final String? image;
  final String? url;
  final String? content;
  final String? code;
  final String? startDate;
  final String? endDate;
  final int? quota;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  PromoModel({
    this.id,
    this.title,
    this.image,
    this.url,
    this.content,
    this.code,
    this.startDate,
    this.endDate,
    this.quota,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      content: json['content'],
      code: json['code'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      quota: json['quota'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  @override
  String toString() =>
      'PromoDetailModel{id: $id, title: $title, image: $image, url: $url, content: $content, code: $code, startDate: $startDate, endDate: $endDate, quota: $quota, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
}
