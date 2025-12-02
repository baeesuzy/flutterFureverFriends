import 'package:flutter/material.dart';

class PetsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> pets;
  const PetsScreen({super.key, required this.pets});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  // categories: use lowercase for comparison
  final List<String> categories = ['all', 'dog', 'cat', 'rabbit', 'bird'];
  String selectedCategory = 'all';

  List<Map<String, dynamic>> get filteredPets {
    if (selectedCategory == 'all') return widget.pets;
    return widget.pets.where((p) {
      // prefer explicit 'type' field
      final typeField = (p['type'] ?? '').toString().toLowerCase();
      if (typeField.isNotEmpty) return typeField == selectedCategory;

      // fallback: infer from image filename if available
      final img = (p['image'] ?? '').toString().toLowerCase();
      if (img.contains('dog')) return selectedCategory == 'dog';
      if (img.contains('cat')) return selectedCategory == 'cat';
      if (img.contains('rabbit')) return selectedCategory == 'rabbit';
      if (img.contains('bird')) return selectedCategory == 'bird';

      // fallback: don't show if unknown
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryChips(),
            const SizedBox(height: 16),
            Expanded(
              child: filteredPets.isEmpty
                  ? Center(
                      child: Text(
                        'No pets found',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        return _buildPetCard(filteredPets[index]);

                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Match HomeScreen app bar style: menu icon and profile avatar
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
                onPressed: () {
                  // keep same behavior as HomeScreen (no change)
                },
              ),
              const Spacer(),
              Text(
                'Pets',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF4A9B8E),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: const AssetImage('assets/profile.jpg'),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    // Show DOG | CAT | RABBIT | BIRD (and All implicitly)
    final display = ['All', 'DOG', 'CAT', 'RABBIT', 'BIRD'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(display.length, (i) {
          final label = display[i];
          final value = label.toLowerCase();
          final isSelected = (selectedCategory == 'all' && value == 'all') ||
              (selectedCategory == value && value != 'all');

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onSelected: (sel) {
                setState(() {
                  selectedCategory = value == 'all' ? 'all' : value;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF4A9B8E),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              avatar: null,
            ),
          );
        }),
      ),
    );
  }

Widget _buildPetCard(Map<String, dynamic> pet) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE SECTION — EXACT SAME BEHAVIOR
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              pet['image'],
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.pets,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),
        ),

        /// TEXT + DETAILS SECTION — EXACT MATCH
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAME + HEART ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pet['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${pet['name']} added to favorites!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color(0xFF4A9B8E),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.teal,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              /// LOCATION ROW
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    pet['location'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              /// GENDER + AGE ROW
              Row(
                children: [
                  Icon(
                    pet['gender'] == 'female' ? Icons.female : Icons.male,
                    size: 16,
                    color: pet['gender'] == 'female'
                        ? Colors.pink[300]
                        : Colors.blue[300],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    pet['age'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



  Widget _buildBottomNav(BuildContext context) {
    // Same bottom bar as HomeScreen. Pets tab should be active here.
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A9B8E),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 2, // Pets tab active
        onTap: (index) {
          switch (index) {
            case 0:
              // Back to Home: since PetsScreen was pushed from Home, just pop
              Navigator.pop(context);
              break;
            case 1:
              // TODO: implement Favorites navigation
              break;
            case 2:
              // already on Pets
              break;
            case 3:
              // TODO: implement Messages navigation
              break;
            case 4:
              // TODO: implement Profile navigation
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}