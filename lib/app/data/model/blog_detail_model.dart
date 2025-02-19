class Author {
  final String? id;
  final String? username;

  Author({this.id, this.username});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'],
    );
  }

  @override
  String toString() => 'Author{id: $id, username: $username}';
}

class Comment {
  final String? id;
  final String? name;
  final String? email;
  final String? comments;
  final String? createdAt;

  Comment({this.id, this.name, this.email, this.comments, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      comments: json['comments'],
      createdAt: json['created_at'],
    );
  }

  @override
  String toString() =>
      'Comment{id: $id, name: $name, email: $email, comments: $comments, createdAt: $createdAt}';
}

class BlogDetailModel {
  final String? id;
  final String? slug;
  final String? title;
  final String? featuredImage;
  final String? excerpt;
  final String? content;
  final String? category;
  final String? userId;
  final Author? author;
  final List<Comment>? comments;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  BlogDetailModel({
    this.id,
    this.slug,
    this.title,
    this.featuredImage,
    this.excerpt,
    this.content,
    this.category,
    this.userId,
    this.author,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) {
    var commentsList = json['comments'] as List;
    List<Comment> comments =
        commentsList.map((i) => Comment.fromJson(i)).toList();

    return BlogDetailModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      featuredImage: json['featured_image'],
      excerpt: json['excerpt'],
      content: json['content'],
      category: json['category'],
      userId: json['user_id'],
      author: Author.fromJson(json['author']),
      comments: comments,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  @override
  String toString() =>
      'BlogDetailModel{id: $id, slug: $slug, title: $title, featuredImage: $featuredImage, excerpt: $excerpt, content: $content, category: $category, userId: $userId, author: $author, comments: $comments, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
}
