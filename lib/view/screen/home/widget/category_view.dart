import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:provider/provider.dart';

import '../../product/brand_and_category_product_screen.dart';
import '../shimmer/category_shimmer.dart';
import 'category_widget.dart';

class CategoryView extends StatefulWidget {
  final bool isHomePage;
  const CategoryView({Key? key, required this.isHomePage}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList.isNotEmpty
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: categoryProvider.categoryList.length > 8
                    ? 8
                    : categoryProvider.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BrandAndCategoryProductScreen(
                                    isBrand: false,
                                    id: categoryProvider.categoryList[index].id
                                        .toString(),
                                    name: categoryProvider
                                        .categoryList[index].name,
                                  )));
                    },
                    child: CategoryWidget(
                        category: categoryProvider.categoryList[index],
                        index: index,
                        length: categoryProvider.categoryList.length),
                  );
                },
              )
            : const CategoryShimmer();
      },
    );
  }
}



// ListView.builder(         
//             padding: EdgeInsets.zero,
//             scrollDirection: Axis.horizontal,
//             // itemCount: categoryProvider.categoryList.length,
//             itemCount: categoryProvider.categoryList.length,
//             // itemExtent: 1
//             shrinkWrap: true,
//             itemBuilder: (BuildContext context, int index) {
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
//                     isBrand: false,
//                     id: categoryProvider.categoryList[index].id.toString(),
//                     name: categoryProvider.categoryList[index].name,
//                   )));
//                 },
//                 child: CategoryWidget(category: categoryProvider.categoryList[index], index: index,length:  categoryProvider.categoryList.length),
//               );
//             },
//           ),