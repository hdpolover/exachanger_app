class BlogModel {
  final String? id;
  final String? slug;
  final String? title;
  final String? featuredImage;
  final String? excerpt;
  final String? content;
  final String? category;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  BlogModel({
    this.id,
    this.slug,
    this.title,
    this.featuredImage,
    this.excerpt,
    this.content,
    this.category,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      featuredImage: json['featured_image'],
      excerpt: json['excerpt'],
      content: json['content'],
      category: json['category'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  @override
  String toString() =>
      'DataModel{id: $id, slug: $slug, title: $title, featuredImage: $featuredImage, excerpt: $excerpt, content: $content, category: $category, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
}
