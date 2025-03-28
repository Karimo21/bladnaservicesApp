import 'package:bladnaservices/screens/home/services/profile_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> providers;

  const SearchScreen({super.key, required this.providers});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late List<Map<String, dynamic>> _filteredProviders;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredProviders = List.from(widget.providers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProviders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProviders = List.from(widget.providers);
      } else {
        _filteredProviders = widget.providers
            .where((provider) =>
                provider['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
                provider['profession'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 100,
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                provider["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  provider["profession"],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF0054A5)),
                        const SizedBox(width: 2),
                        Text(
                          "${provider["rating"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(provider: provider),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0054A5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(80, 30),
                      ),
                      child: const Text(
                        "Détails",
                        style: TextStyle(color: Colors.white, fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProviders,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Recherche ici...",
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 26),
                  //    suffixIcon: const Icon(Icons.tune, color: Colors.grey, size: 24),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFF0054A5), width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProviders.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun prestataire trouvé',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _filteredProviders.length,
                      itemBuilder: (context, index) =>
                          _buildProviderCard(_filteredProviders[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
