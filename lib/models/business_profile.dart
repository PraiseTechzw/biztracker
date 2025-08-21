class BusinessProfile {
  int? id;
  
  // Basic Information
  late String businessName;
  late String businessType; // 'retail', 'wholesale', 'service', 'manufacturing', etc.
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
  late DateTime createdAt;
  late DateTime updatedAt;

  // Constructor
  BusinessProfile({
    this.id,
    required this.businessName,
    required this.businessType,
    this.businessDescription,
    this.phoneNumber,
    this.email,
    this.website,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.taxId,
    this.registrationNumber,
    this.industry,
    this.currency,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.isActive = true,
    this.logoPath,
    this.bannerPath,
    this.hasShownFirstSaleAchievement = false,
    this.hasShownProfitMilestoneAchievement = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessName': businessName,
      'businessType': businessType,
      'businessDescription': businessDescription,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'taxId': taxId,
      'registrationNumber': registrationNumber,
      'industry': industry,
      'currency': currency,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'isActive': isActive ? 1 : 0,
      'logoPath': logoPath,
      'bannerPath': bannerPath,
      'hasShownFirstSaleAchievement': hasShownFirstSaleAchievement ? 1 : 0,
      'hasShownProfitMilestoneAchievement': hasShownProfitMilestoneAchievement ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map from SQLite
  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    return BusinessProfile(
      id: map['id'],
      businessName: map['businessName'],
      businessType: map['businessType'],
      businessDescription: map['businessDescription'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      website: map['website'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      postalCode: map['postalCode'],
      taxId: map['taxId'],
      registrationNumber: map['registrationNumber'],
      industry: map['industry'],
      currency: map['currency'],
      ownerName: map['ownerName'],
      ownerPhone: map['ownerPhone'],
      ownerEmail: map['ownerEmail'],
      isActive: map['isActive'] == 1,
      logoPath: map['logoPath'],
      bannerPath: map['bannerPath'],
      hasShownFirstSaleAchievement: map['hasShownFirstSaleAchievement'] == 1,
      hasShownProfitMilestoneAchievement: map['hasShownProfitMilestoneAchievement'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Helper method to check if profile is complete
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
