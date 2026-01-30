import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// FIX: Corrected import name
import '../logics/category_logic.dart'; 
import '../models/category_model.dart';
import '../widgets/my_load_more.dart';
import '../widgets/my_simple_card.dart';
import '../logics/product_logic.dart';
import '../widgets/my_loading.dart';
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
    
    // 1. Fetch data on launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryLogic>().read();
      context.read<ProductLogic>().readProductPagination();
    });

    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        setState(() {
          _showUpIcon = true;
        });
      } else {
        setState(() {
          _showUpIcon = false;
        });
      }

      if (_scroller.position.pixels >= _scroller.position.maxScrollExtent) {
        debugPrint("reached bottom");
        context.read<ProductLogic>().readProductPagination();
      }
    });
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_upward),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TEN11")),
      body: _buildBody(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
    );
  }

  Widget _buildBody() {
    return _buildListView();
  }

  String _selectedId = "-1";

  Widget _buildListView() {
    bool hasMoreRecords = context.watch<ProductLogic>().hasMoreRecords;
    String selectedId = context.watch<ProductLogic>().catId;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductLogic>().resetCatId();
        context.read<ProductLogic>().setLoading();
        await context.read<CategoryLogic>().read();
        await context.read<ProductLogic>().readProductPagination(refresh: true);
      },
      child: ListView(
        controller: _scroller,
        // 1. ADD THIS LINE HERE
        physics: const BouncingScrollPhysics(), 
        children: [
          _buildCategoryList(selectedId),
          _buildProductGridView(),
          hasMoreRecords ? MyLoadMore(context) : const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String selectedId) {
    List<Cat> items = context.watch<CategoryLogic>().cats;

    return SizedBox(
      height: kMinInteractiveDimension,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // 2. ADD THIS LINE HERE TOO
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          bool isSelected = selectedId == item.id.toString();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isSelected
                  ? null 
                  : () {
                      context.read<ProductLogic>().setCatId(item.id);
                      context.read<ProductLogic>().setLoading();
                      context.read<ProductLogic>().readProductPagination(refresh: true);
                    },
              child: Text(item.name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridView() {
    bool loading = context.watch<ProductLogic>().loading;
    List<Product> items = context.watch<ProductLogic>().products;

    // Only show full loading if list is empty, otherwise show list
    if (loading && items.isEmpty) {
      return SizedBox(
        height: 400,
        child: MyLoading(context),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 500,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Check if images exist to prevent crashes
          String img = item.images.isNotEmpty ? item.images[0] : "";
          return MySimpleCard(context, img, item.title);
        },
      );
    }
  }
}