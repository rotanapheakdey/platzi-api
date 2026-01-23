import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels == _scroller.position.maxScrollExtent) {
        debugPrint("reached bottom");
        context.read<ProductLogic>().readProductPagination();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNRHMRbBL8BAcMYo3mmhwF-yp9Qku7B6v0hQ&s";
    return Scaffold(
      appBar: AppBar(title: Text("TEN11")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    bool loading = context.watch<ProductLogic>().loading;
    List<Product> products = context.watch<ProductLogic>().products;

    if (loading) {
      return MyLoading(context);
    } else {
      return _buildGridView(products);
    }
  }

  Widget _buildGridView(List<Product> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductLogic>().setLoading();
        context.read<ProductLogic>().readProductPagination(refresh: true);
      },
      child: GridView.builder(
        controller: _scroller,
        cacheExtent: 500,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.images[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
