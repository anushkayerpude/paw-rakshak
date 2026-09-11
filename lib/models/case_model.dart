import 'package:flutter/material.dart';

class RescueCase {
  final String id;
  final String species;
  final String emoji;
  final String? imagePath;
  final String severity; // 'Critical', 'High', 'Medium'
  final Color severityColor;
  final String description;
  final String location;
  final String distance;
  final String timeAgo;
  final String status; // 'Awaiting Rescuer', 'Rescuer En Route', 'At Clinic', 'Recovered'
  final int responders;
  final String? userResponseRole;
  final int donationsRaised;
  final DateTime createdAt;

  const RescueCase({
    required this.id,
    required this.species,
    required this.emoji,
    this.imagePath,
    required this.severity,
    required this.severityColor,
    required this.description,
    required this.location,
    required this.distance,
    required this.timeAgo,
    required this.status,
    required this.responders,
    this.userResponseRole,
    this.donationsRaised = 0,
    required this.createdAt,
  });

  RescueCase copyWith({
    String? status,
    int? responders,
    String? userResponseRole,
    int? donationsRaised,
    String? imagePath,
  }) {
    return RescueCase(
      id: id,
      species: species,
      emoji: emoji,
      imagePath: imagePath ?? this.imagePath,
      severity: severity,
      severityColor: severityColor,
      description: description,
      location: location,
      distance: distance,
      timeAgo: timeAgo,
      status: status ?? this.status,
      responders: responders ?? this.responders,
      userResponseRole: userResponseRole ?? this.userResponseRole,
      donationsRaised: donationsRaised ?? this.donationsRaised,
      createdAt: createdAt,
    );
  }
}
