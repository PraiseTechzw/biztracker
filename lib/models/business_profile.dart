import 'package:isar/isar.dart';

part 'business_profile.g.dart';

@collection
class BusinessProfile {
  Id id = Isar.autoIncrement;

  // Basic Information
  late String businessName;
  late String businessType; // 'retail', 'wholesale', 'service', 'manufacturing', etc.
  late String? businessDescription;
  
  // Contact Information
  late String? phoneNumber;
  late String? email;
  late String? website;
  
  // Address Information
  late String? address;
  late String? city;
  late String? state;
  late String? country;
  late String? postalCode;
  
  // Business Details
  late String? taxId;
  late String? registrationNumber;
  late String? industry;
  late String? currency; // Default currency for transactions
  
  // Owner Information
  late String? ownerName;
  late String? ownerPhone;
  late String? ownerEmail;
  
  // Business Settings
  late bool isActive;
  late String? logoPath; // Path to stored logo image
  late String? bannerPath; // Path to stored banner image
  
  // Timestamps
  @Index()
  late DateTime createdAt;
  
  @Index()
  late DateTime updatedAt;
  
  // Helper method to check if profile is complete
  bool get isProfileComplete {
    return businessName.isNotEmpty && 
           businessType.isNotEmpty && 
           phoneNumber != null && 
           phoneNumber!.isNotEmpty;
  }
  
  // Helper method to get full address
  String get fullAddress {
    List<String> addressParts = [];
    if (address != null && address!.isNotEmpty) addressParts.add(address!);
    if (city != null && city!.isNotEmpty) addressParts.add(city!);
    if (state != null && state!.isNotEmpty) addressParts.add(state!);
    if (postalCode != null && postalCode!.isNotEmpty) addressParts.add(postalCode!);
    if (country != null && country!.isNotEmpty) addressParts.add(country!);
    
    return addressParts.join(', ');
  }
  
  // Helper method to get display name
  String get displayName {
    return businessName.isNotEmpty ? businessName : 'Unnamed Business';
  }
} 