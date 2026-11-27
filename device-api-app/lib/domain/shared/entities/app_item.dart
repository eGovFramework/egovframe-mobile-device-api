class AppItem {
  final String title;
  final String subtitle;
  final String description;
  final String? targetPage;
  final bool hasIcon;
  final String? iconUrl;

  AppItem({
    required this.title,
    required this.subtitle,
    required this.description,
    this.targetPage,
    this.hasIcon = false,
    this.iconUrl,
  });

  factory AppItem.fromJson(Map<String, dynamic> json) {
    return AppItem(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      targetPage: json['targetPage'],
      hasIcon: json['hasIcon'] ?? false,
      iconUrl: json['iconUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': title,
      'description': description,
      'targetPage': targetPage,
      'hasIcon': hasIcon,
      'iconUrl': iconUrl,
    };
  }
}
