import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.productList});
  final List<ProductModel> productList;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: widget.productList.length < 3 ? widget.productList.length : 3,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final product = widget.productList[index];
        return Card(
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(
                  Icons.production_quantity_limits,
                  size: 30,
                ),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productname ?? '',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Quantity: ${product.quantity ?? ''}",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
