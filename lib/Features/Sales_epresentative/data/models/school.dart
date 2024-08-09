List<School> schools = [
  School(name: 'School A', location: 'Location A'),
  School(name: 'School B', location: 'Location B'),
  School(name: 'School C', location: 'Location C'),
  // Add more schools as needed
];
class School {
  final String name;
  final String location;

  School({
    required this.name,
    required this.location,
  });
}