import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';

class Contact {
  // Name
  final String? displayName, givenName, middleName, prefix, suffix, familyName;

// Company
  final String? company, jobTitle;

// Email addresses
  final List<Item>? emails = [];

// Phone numbers
  final List<Item>? phones = [];

// Post addresses
  final List<PostalAddress>? postalAddresses = [];

// Contact avatar/thumbnail
  final Uint8List? avatar;

  Contact(
      {required this.displayName,
      required this.givenName,
      required this.middleName,
      required this.prefix,
      required this.suffix,
      required this.familyName,
      required this.company,
      required this.jobTitle,
      required this.avatar});
}
