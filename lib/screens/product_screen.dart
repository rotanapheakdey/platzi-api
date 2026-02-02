import 'package:flutter/material.dart';
import '../widgets/my_3line_card.dart';
import '../logics/category_logic.dart';
import '../models/category_model.dart';
import '../widgets/my_load_more.dart';
import '../widgets/my_simple_card.dart';
import '../logics/product_logic.dart';
import '../widgets/my_loading.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scroller = ScrollController();
  bool _showUpIcon = false;

  @override
  void initState() {
    super.initState();
    
    // ... logic for initial load ...
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryLogic>().read();
      context.read<ProductLogic>().readProductPagination();
    });

    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        if (!_showUpIcon) setState(() => _showUpIcon = true);
      } else {
        if (_showUpIcon) setState(() => _showUpIcon = false);
      }

      // FIX: Only load more if we have data AND we aren't already loading
      // This stops the infinite loop on empty screens!
      if (_scroller.position.pixels >= _scroller.position.maxScrollExtent) {
        final logic = context.read<ProductLogic>();
        if (!logic.loading && logic.products.isNotEmpty) {
           debugPrint("reached bottom - loading more");
           logic.readProductPagination();
        }
      }
    });
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    final logo =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNRHMRbBL8BAcMYo3mmhwF-yp9Qku7B6v0hQ&s";
    return Scaffold(
      appBar: AppBar(
        title: Text("TEN11"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
            icon: Icon(_isGrid ? Icons.grid_on : Icons.list),
          ),
          IconButton(
            onPressed: () async {
              bool applied = await _showTuneDialog() ?? false;
              if (applied) {
                context.read<ProductLogic>().setLoading();
                
                // Clear the list and fetch NEW data with filters
                context.read<ProductLogic>().readProductPagination(
                  refresh: true, 
                  minPrice: int.tryParse(_minCtrl.text.trim()),
                  maxPrice: int.tryParse(_maxCtrl.text.trim()),
                );
              }
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
    );
  }

  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  Future<bool?> _showTuneDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set Price Range"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _minCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.currency_exchange),
                  hintText: "Enter min price",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _maxCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.currency_exchange),
                  hintText: "Enter max price",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    //remove this code
    return _buildListView();
  }

  String _selectedId = "-1";

  Widget _buildListView() {
    bool hasMoreRecords = context.read<ProductLogic>().hasMoreRecords;
    _selectedId = context.watch<ProductLogic>().catId;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductLogic>().resetCatId();
        context.read<ProductLogic>().setLoading();
        context.read<CategoryLogic>().read();
        context.read<ProductLogic>().readProductPagination(refresh: true);
      },
      child: ListView(
        controller: _scroller,
        physics: BouncingScrollPhysics(),
        children: [
          _buildCategoryList(),
          _buildProductGridView(),
          hasMoreRecords ? MyLoadMore(context) : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    List<Cat> items = context.watch<CategoryLogic>().cats;

    return SizedBox(
      height: kMinInteractiveDimension, // = 48.0
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _selectedId == item.id
                  ? null
                  : () {
                      debugPrint("item.id: ${item.id}");
                      context.read<ProductLogic>().setCatId(item.id);
                      context.read<ProductLogic>().setLoading();
                      context.read<ProductLogic>().readProductPagination(
                            refresh: true,
                          );
                    },
              child: Text("${item.name}"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridView() {
    // 1. Get the logic values
    final logic = context.watch<ProductLogic>();
    bool loading = logic.loading;
    List<Product> items = logic.products;
    String? error = logic.error; // Get the error message

    SliverGridDelegate delegate;
    Widget loadingWidget;

    if (_isGrid) {
      delegate = const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      );
      loadingWidget = MyLoading(context);
    } else {
      delegate = const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 1,
      );
      loadingWidget = MyLoading(context, crossAxisCount: 1, childAspectRatio: 3/1);
    }

    // 2. CHECK FOR ERRORS FIRST
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              const Text("Something went wrong:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                   context.read<ProductLogic>().readProductPagination(refresh: true);
                },
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      );
    }

    if (loading && items.isEmpty) {
      return loadingWidget;
    } else if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey),
            Text("No products found"),
          ],
        ),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 500,
        gridDelegate: delegate,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return My3LineCard(
            context,
            item.images.isNotEmpty ? item.images[0] : "",
            item.title,
            item.category.name,
            "USD \$${item.price}",
          );
        },
      );
    }
  }
}
