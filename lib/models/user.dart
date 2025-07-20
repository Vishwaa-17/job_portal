
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String phoneNo;
  final String uid;
  final String? userType;

  // Job Seeker Personal Details
  final String? name;
  final String? dob;
  final String? gender;
  final String? state;
  final String? city;

  // Job Seeker Work Details
  final String? company;    // Previous company
  final String? position;   // Previous position
  final String? duration;   // Work duration

  // Recruiter Company Details
  final String? companyName;
  final String? industry;
  final String? recruiterLocation;
  final String? website;

  User({
    required this.email,
    required this.phoneNo,
    required this.uid,
    required this.userType,
    this.name,
    this.dob,
    this.gender,
    this.state,
    this.city,
    this.company,
    this.position,
    this.duration,
    this.companyName,
    this.industry,
    this.recruiterLocation,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNo': phoneNo,
      'uid': uid,
      'userType': userType,
      'name': name,
      'dob': dob,
      'gender': gender,
      'state': state,
      'city': city,
      'company': company,
      'position': position,
      'duration': duration,
      'companyName': companyName,
      'industry': industry,
      'recruiterLocation': recruiterLocation,
      'website': website,
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      phoneNo: snapshot['phoneNo'],
      uid: snapshot['uid'],
      userType: snapshot['userType'],
      name: snapshot['name'],
      dob: snapshot['dob'],
      gender: snapshot['gender'],
      state: snapshot['state'],
      city: snapshot['city'],
      company: snapshot['company'],
      position: snapshot['position'],
      duration: snapshot['duration'],
      companyName: snapshot['companyName'],
      industry: snapshot['industry'],
      recruiterLocation: snapshot['recruiterLocation'],
      website: snapshot['website'],
    );
  }
}
