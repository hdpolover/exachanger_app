class MetaDataModel {
  final String? id;
  final String? page;
  final List<ContentModel>? content;
  final String? updatedAt;

  MetaDataModel({
    this.id,
    this.page,
    this.content,
    this.updatedAt,
  });

  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    return MetaDataModel(
      id: json['id'],
      page: json['page'],
      content: json['content'] != null
          ? List<ContentModel>.from(
              json['content'].map((x) => ContentModel.fromJson(x)))
          : null,
      updatedAt: json['updated_at'],
    );
  }

  @override
  String toString() {
    return 'MetaData{id: $id, page: $page, content: $content, updatedAt: $updatedAt}';
  }
}

class ContentModel {
  final SectionModel? section;

  ContentModel({
    this.section,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      section: SectionModel.fromJson(json['section'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'Content{section: $section}';
  }
}

class SectionModel {
  final String? code;
  final String? title;
  final int? order;
  final dynamic backgroundColor;
  final List<ComponentModel>? components;

  SectionModel({
    this.code,
    this.title,
    this.order,
    this.backgroundColor,
    this.components,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      code: json['code'],
      title: json['title'],
      order: json['order'],
      backgroundColor: json['background-color'],
      components: json['components'] != null
          ? List<ComponentModel>.from(
              json['components'].map((x) => ComponentModel.fromJson(x)))
          : null,
    );
  }

  @override
  String toString() {
    return 'Section{code: $code, title: $title, order: $order, backgroundColor: $backgroundColor, components: $components}';
  }
}

class ComponentModel {
  final int? order;
  final String? title;
  final String? component;
  final String? type;
  final String? textColor;
  final dynamic backgroundColor;
  final String? data;

  ComponentModel({
    this.order,
    this.title,
    this.component,
    this.type,
    this.textColor,
    this.backgroundColor,
    this.data,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      order: json['order'],
      title: json['title'],
      component: json['component'],
      type: json['type'],
      textColor: json['text-color'],
      backgroundColor: json['background-color'],
      data: json['data'],
    );
  }

  @override
  String toString() {
    return 'Component{order: $order, title: $title, component: $component, type: $type, textColor: $textColor, backgroundColor: $backgroundColor, data: $data}';
  }
}
