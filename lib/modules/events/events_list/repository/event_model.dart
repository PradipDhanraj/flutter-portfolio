class Event {
  final String title;
  final int? id;
  final DateTime event_date;
  final String? payment_id;
  final DateTime? created_at;
  final String? event_id;
  final double? longitude;
  final double? latitude;
  final String? owner_id;
  final String? imageUrl;
  final String? location;
  final String? username;

  Event({
    required this.title,
    this.id,
    required this.event_date,
    this.payment_id,
    this.created_at,
    this.event_id,
    this.longitude,
    this.latitude,
    this.owner_id,
    this.imageUrl,
    this.location,
    this.username,
  });

  Event copyWith({
    String? title,
    int? id,
    DateTime? event_date,
    String? payment_id,
    DateTime? created_at,
    String? event_id,
    double? longitude,
    double? latitude,
    String? owner_id,
    String? imageUrl,
    String? location,
    String? username,
  }) {
    return Event(
      title: title ?? this.title,
      id: id ?? this.id,
      event_date: event_date ?? this.event_date,
      payment_id: payment_id ?? this.payment_id,
      created_at: created_at ?? this.created_at,
      event_id: event_id ?? this.event_id,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      owner_id: owner_id ?? this.owner_id,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      username: username ?? this.username,
    );
  }

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      title: map['title'] ?? '',
      id: map['id'],
      event_date:
          map['event_date'] is String
              ? DateTime.tryParse(map['event_date']) ?? DateTime.now()
              : (map['event_date'] ?? DateTime.now()),
      payment_id: map['payment_id'],
      created_at:
          map['created_at'] is String
              ? DateTime.tryParse(map['created_at'])
              : map['created_at'],
      event_id: map['event_id'],
      longitude:
          map['longitude'] is num ? (map['longitude'] as num).toDouble() : null,
      latitude:
          map['latitude'] is num ? (map['latitude'] as num).toDouble() : null,
      owner_id: map['owner_id'],
      imageUrl: map['imageUrl'],
      location: map['location'],
      username: map['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      //'id': id,
      'event_date': event_date.toIso8601String(),
      'payment_id': payment_id,
      'created_at': created_at?.toIso8601String(),
      'event_id': event_id,
      'longitude': longitude,
      'latitude': latitude,
      'owner_id': owner_id,
      'imageUrl': imageUrl,
      'location': location,
      'username': username,
    };
  }
}
