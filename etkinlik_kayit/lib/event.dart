class Event {
  final int id;
  final String name;
  final String description;
  final String location;
  final DateTime date;
  final int registeredUsers;
  final int totalSlots;
  final String imageUrl;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.registeredUsers,
    required this.totalSlots,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      registeredUsers: json['registered_users'],
      totalSlots: json['total_slots'],
      imageUrl: json['image'],
    );
  }
}
