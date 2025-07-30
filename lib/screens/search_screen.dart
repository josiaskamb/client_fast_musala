import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'booking_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialService;

  const SearchScreen({super.key, this.initialService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedService = 'Plombier';
  String _selectedCommune = 'Gombe';
  double _maxDistance = 10.0; // en km

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      _selectedService = widget.initialService!;
    }
  }

  final List<Map<String, dynamic>> _artisans = [
    {
      'name': 'Jean Kabasele',
      'service': 'Plombier',
      'rating': 4.8,
      'commune': 'Gombe',
      'distance': 2.3,
      'price': '25\$',
      'image': 'plumber.jpg',
    },
    {
      'name': 'Marc Tshibangu',
      'service': 'Électricien',
      'rating': 4.5,
      'commune': 'Lingwala',
      'distance': 3.1,
      'price': '30\$',
      'image': 'electrician.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trouver un Artisan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildServiceSelector(),
                const SizedBox(height: 8),
                _buildLocationRow(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _artisans.length,
              itemBuilder: (context, index) {
                final artisan = _artisans[index];
                return _buildArtisanCard(artisan);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher un service...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildServiceSelector() {
    const services = ['Plombier', 'Électricien', 'Mécanicien', 'Menuisier'];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(services[index]),
            selected: _selectedService == services[index],
            onSelected: (selected) {
              setState(() => _selectedService = services[index]);
            },
            selectedColor: AppColors.primaryGreen,
          );
        },
      ),
    );
  }

  Widget _buildLocationRow() {
    const communes = ['Gombe', 'Lingwala', 'Kasa-Vubu', 'Ngaliema'];

    return Row(
      children: [
        const Icon(Icons.location_on, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedCommune,
            items: communes.map((commune) {
              return DropdownMenuItem(
                value: commune,
                child: Text(commune),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCommune = value!),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArtisanCard(Map<String, dynamic> artisan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(artisan: artisan),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
            CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(artisan['image'])),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artisan['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${artisan['service']} • ${artisan['distance']} km',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${artisan['rating']}'),
                      const Spacer(),
                      Text(
                        artisan['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
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

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrer les résultats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Distance maximale:'),
                  ),
                  Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_maxDistance.round()} km',
                    onChanged: (value) => setState(() => _maxDistance = value),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Appliquer les filtres'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}