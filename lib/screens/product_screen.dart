import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/product_logic.dart';
import '../models/product_model.dart';
import '../widgets/my_loading.dart';

// --- WIDGET 1: Simple Load More Indicator ---
Widget MyLoadMore(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(20.0),
    child: Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}

// --- WIDGET 2: Simple Product Card (FIXED TYPES) ---
// Changed 'double price' to 'dynamic price' to handle both String and Int safely
Widget MySimpleCard(BuildContext context, String imageUrl, String title, dynamic price) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[200]),
              errorWidget: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "\$$price", // This will print nicely whether it's a String or Number
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// --- MAIN SCREEN ---
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scroller = ScrollController();
  bool _showUpIcon = false;
  
  // FIX 1: Changed from int to String to match your Model
  String _selectedCategoryId = "0"; 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductLogic>().readCategories();
      if (context.read<ProductLogic>().products.isEmpty) {
         context.read<ProductLogic>().readProductPagination();
      }
    });

    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        if (!_showUpIcon) setState(() => _showUpIcon = true);
      } else {
        if (_showUpIcon) setState(() => _showUpIcon = false);
      }

      if (_scroller.position.pixels >= _scroller.position.maxScrollExtent - 50) {
        context.read<ProductLogic>().readProductPagination();
      }
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      backgroundColor: Colors.cyan.shade300,
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_upward, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade200,
        title: const Text("TEN11", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _buildListView(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
    );
  }

  Widget _buildListView() {
    bool loading = context.watch<ProductLogic>().loading;
    List<Product> products = context.watch<ProductLogic>().products;

    return RefreshIndicator(
      onRefresh: () async {
        _selectedCategoryId = "0"; // Reset filter
        context.read<ProductLogic>().setLoading();
        context.read<ProductLogic>().readCategories();
        await context.read<ProductLogic>().readProductPagination(refresh: true);
      },
      child: ListView(
        controller: _scroller,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCategoryList(),
          
          if (loading && products.isEmpty)
             SizedBox(height: 300, child: MyLoading(context))
          else
             _buildProductGridView(products),

          if (loading && products.isNotEmpty) 
             MyLoadMore(context),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    List<Category> items = context.watch<ProductLogic>().categories;

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // FIX 2: Using .toString() ensures comparison works safely
          final isSelected = _selectedCategoryId == item.id.toString();

          return Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.cyan.shade300 : Colors.grey.shade100,
                elevation: isSelected ? 2 : 0,
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                setState(() {
                  // FIX 3: Convert to String safely
                  _selectedCategoryId = item.id.toString();
                });
                debugPrint("Selected Category: ${item.name}");
              },
              child: Text(item.name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridView(List<Product> items) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), 
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        String img = item.images.isNotEmpty ? item.images[0] : "";
        
        // FIX 4: Passing item.price directly (MySimpleCard now accepts dynamic)
        return MySimpleCard(context, img, item.title, item.price);
      },
    );
  }
}