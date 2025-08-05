import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/glassmorphism_theme.dart';
import '../models/business_profile.dart';
import '../services/database_service.dart';
import 'main_navigation_screen.dart';

class BusinessProfileScreen extends StatefulWidget {
  final BusinessProfile? existingProfile;

  const BusinessProfileScreen({super.key, this.existingProfile});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _businessNameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _industryController = TextEditingController();
  final _currencyController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();

  // Form state
  String _selectedBusinessType = 'retail';
  String _selectedCurrency = 'USD';
  bool _isLoading = false;
  bool _isActive = true;
  bool _showMoreDetails = false;

  final List<String> _businessTypes = [
    'retail',
    'wholesale',
    'service',
    'manufacturing',
    'restaurant',
    'e-commerce',
    'consulting',
    'other',
  ];

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
    'MXN',
    'KRW',
    'SGD',
    'HKD',
    'NZD',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  void _loadExistingProfile() {
    if (widget.existingProfile != null) {
      final profile = widget.existingProfile!;
      _businessNameController.text = profile.businessName;
      _selectedBusinessType = profile.businessType;
      _businessDescriptionController.text = profile.businessDescription ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
      _emailController.text = profile.email ?? '';
      _websiteController.text = profile.website ?? '';
      _addressController.text = profile.address ?? '';
      _cityController.text = profile.city ?? '';
      _stateController.text = profile.state ?? '';
      _countryController.text = profile.country ?? '';
      _postalCodeController.text = profile.postalCode ?? '';
      _taxIdController.text = profile.taxId ?? '';
      _registrationNumberController.text = profile.registrationNumber ?? '';
      _industryController.text = profile.industry ?? '';
      _selectedCurrency = profile.currency ?? 'USD';
      _ownerNameController.text = profile.ownerName ?? '';
      _ownerPhoneController.text = profile.ownerPhone ?? '';
      _ownerEmailController.text = profile.ownerEmail ?? '';
      _isActive = profile.isActive;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _businessDescriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _taxIdController.dispose();
    _registrationNumberController.dispose();
    _industryController.dispose();
    _currencyController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = BusinessProfile()
        ..businessName = _businessNameController.text.trim()
        ..businessType = _selectedBusinessType
        ..businessDescription =
            _businessDescriptionController.text.trim().isEmpty
            ? null
            : _businessDescriptionController.text.trim()
        ..phoneNumber = _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim()
        ..email = _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim()
        ..website = _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim()
        ..address = _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim()
        ..city = _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim()
        ..state = _stateController.text.trim().isEmpty
            ? null
            : _stateController.text.trim()
        ..country = _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim()
        ..postalCode = _postalCodeController.text.trim().isEmpty
            ? null
            : _postalCodeController.text.trim()
        ..taxId = _taxIdController.text.trim().isEmpty
            ? null
            : _taxIdController.text.trim()
        ..registrationNumber = _registrationNumberController.text.trim().isEmpty
            ? null
            : _registrationNumberController.text.trim()
        ..industry = _industryController.text.trim().isEmpty
            ? null
            : _industryController.text.trim()
        ..currency = _selectedCurrency
        ..ownerName = _ownerNameController.text.trim().isEmpty
            ? null
            : _ownerNameController.text.trim()
        ..ownerPhone = _ownerPhoneController.text.trim().isEmpty
            ? null
            : _ownerPhoneController.text.trim()
        ..ownerEmail = _ownerEmailController.text.trim().isEmpty
            ? null
            : _ownerEmailController.text.trim()
        ..isActive = _isActive
        ..createdAt = widget.existingProfile?.createdAt ?? DateTime.now()
        ..updatedAt = DateTime.now();

      await DatabaseService.saveBusinessProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingProfile != null
                  ? 'Profile updated successfully!'
                  : 'Profile created successfully!',
            ),
            backgroundColor: GlassmorphismTheme.primaryColor,
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigationScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _skipProfile() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingProfile != null
              ? 'Edit Business Profile'
              : 'Create Business Profile',
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E1B4B)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Friendly intro
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Let’s get started! Just tell us your business name and type. You can add more details later.',
                          style: TextStyle(
                            color: GlassmorphismTheme.textSecondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Basic Information Section (Required)
                      _buildSectionHeader('Basic Info', Icons.business),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _businessNameController,
                        label: 'Business Name',
                        hint: 'e.g. Sarah’s Shop',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Business name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Business Type',
                        value: _selectedBusinessType,
                        items: _businessTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBusinessType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone (optional)',
                        hint: 'e.g. +1 555 123 4567',
                        keyboardType: TextInputType.phone,
                        validator: null,
                      ),
                      const SizedBox(height: 24),
                      // More Details (Optional)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMoreDetails = !_showMoreDetails;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              _showMoreDetails
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _showMoreDetails
                                  ? 'Hide More Details'
                                  : 'Add More Details (Optional)',
                              style: TextStyle(
                                color: GlassmorphismTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _businessDescriptionController,
                              label: 'Business Description',
                              hint: 'Describe your business (optional)',
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'Enter business email',
                              keyboardType: TextInputType.emailAddress,
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _websiteController,
                              label: 'Website',
                              hint: 'Enter website URL (optional)',
                              keyboardType: TextInputType.url,
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _addressController,
                              label: 'Street Address',
                              hint: 'Enter street address',
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cityController,
                                    label: 'City',
                                    hint: 'Enter city',
                                    validator: null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _stateController,
                                    label: 'State/Province',
                                    hint: 'Enter state',
                                    validator: null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _countryController,
                                    label: 'Country',
                                    hint: 'Enter country',
                                    validator: null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _postalCodeController,
                                    label: 'Postal Code',
                                    hint: 'Enter postal code',
                                    validator: null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _taxIdController,
                              label: 'Tax ID',
                              hint:
                                  'Enter tax identification number (optional)',
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _registrationNumberController,
                              label: 'Registration Number',
                              hint:
                                  'Enter business registration number (optional)',
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _industryController,
                              label: 'Industry',
                              hint: 'Enter your industry (optional)',
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField(
                              label: 'Default Currency',
                              value: _selectedCurrency,
                              items: _currencies
                                  .map(
                                    (currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _ownerNameController,
                              label: 'Owner Name',
                              hint: 'Enter owner name (optional)',
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _ownerPhoneController,
                              label: 'Owner Phone',
                              hint: 'Enter owner phone (optional)',
                              keyboardType: TextInputType.phone,
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _ownerEmailController,
                              label: 'Owner Email',
                              hint: 'Enter owner email (optional)',
                              keyboardType: TextInputType.emailAddress,
                              validator: null,
                            ),
                            const SizedBox(height: 16),
                            GlassmorphismTheme.glassmorphismContainer(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text(
                                      'Active Business',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: GlassmorphismTheme.textColor,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: _isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        _isActive = value;
                                      });
                                    },
                                    activeColor:
                                        GlassmorphismTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: _showMoreDetails
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              // Save & Skip Buttons
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _skipProfile,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GlassmorphismTheme.primaryColor,
                          side: const BorderSide(
                            color: GlassmorphismTheme.primaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Skip for now'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlassmorphismTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.existingProfile != null
                                    ? 'Update Profile'
                                    : 'Save & Continue',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: GlassmorphismTheme.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: GlassmorphismTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: GlassmorphismTheme.textColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: GlassmorphismTheme.textSecondaryColor,
          ),
          hintStyle: const TextStyle(
            color: GlassmorphismTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        style: const TextStyle(color: GlassmorphismTheme.textColor),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: GlassmorphismTheme.textSecondaryColor,
          ),
        ),
        dropdownColor: GlassmorphismTheme.surfaceColor,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: GlassmorphismTheme.textSecondaryColor,
        ),
      ),
    );
  }
}
