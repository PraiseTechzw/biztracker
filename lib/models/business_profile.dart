import 'package:isar/isar.dart';

part 'business_profile.g.dart';

@collection
class BusinessProfile {
  Id id = Isar.autoIncrement;

  // Basic Information
  late String businessName;
  late String
  businessType; // 'retail', 'wholesale', 'service', 'manufacturing', etc.
  String? businessDescription;

  // Contact Information
  String? phoneNumber;
  String? email;
  String? website;

  // Address Information
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;

  // Business Details
  String? taxId;
  String? registrationNumber;
  String? industry;
  String? currency; // Default currency for transactions

  // Owner Information
  String? ownerName;
  String? ownerPhone;
  String? ownerEmail;

  // Business Settings
  bool isActive = true;
  String? logoPath; // Path to stored logo image
  String? bannerPath; // Path to stored banner image

  // Achievement tracking
  bool hasShownFirstSaleAchievement = false;
  bool hasShownProfitMilestoneAchievement = false;

  // Timestamps
  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  // Helper method to check if profile is complete
  @ignore
  bool get isProfileComplete {
    return businessName.isNotEmpty && businessType.isNotEmpty;
  }

  // Helper method to get full address
  String get fullAddress {
    List<String> addressParts = [];
    if (address != null && address!.isNotEmpty) addressParts.add(address!);
    if (city != null && city!.isNotEmpty) addressParts.add(city!);
    if (state != null && state!.isNotEmpty) addressParts.add(state!);
    if (postalCode != null && postalCode!.isNotEmpty) {
      addressParts.add(postalCode!);
    }
    if (country != null && country!.isNotEmpty) addressParts.add(country!);

    return addressParts.join(', ');
  }

  // Helper method to get display name
  String get displayName {
    return businessName.isNotEmpty ? businessName : 'Unnamed Business';
  }
}
