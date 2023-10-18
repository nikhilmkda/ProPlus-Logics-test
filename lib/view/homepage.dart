import 'package:ecommerce/view/product_expanded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controller/product_list_provider.dart';
import '../controller/upload_products_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Function to build a widget that displays either an image or video
  Widget buildProductImage(String imageUrl) {
    if (imageUrl.endsWith('.mp4')) {
      // Display video if the URL ends with '.mp4'
      final videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(imageUrl));
      return AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
        child: VideoPlayer(videoPlayerController),
      );
    } else {
      // Display image for other cases
      return Image.network(
        imageUrl,
        width: 150,
        height: 100,
        errorBuilder: (context, error, stackTrace) {
          // Display a placeholder image or an error message
          return Image.asset(
            'assets/errorImage.png',
            width: 150,
            height: 100,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ProductProvider
    final productProvider = Provider.of<ProductListProvider>(context);
    final uploadProductsProvider = Provider.of<UploadProductsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_to_photos_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              uploadProductsProvider.clearControllers();
              Navigator.pushNamed(context, '/postProductScreen');
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Product listing",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                hintText: 'search for car models/brands',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade800,
                  size: 25, // Customize the icon color
                ),
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder(
              future: productProvider.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    productProvider.hasNetworkError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/noresult.png',
                          width: 400,
                          height: 400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          productProvider.hasNetworkError
                              ? 'Failed to load data, check your internet connection'
                              : 'Error: ${snapshot.error}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Build the grid view using the fetched data
                  final products = productProvider
                      .products; // Assuming ProductProvider has a 'products' property
                  return Expanded(
                    child: GridView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.9),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to a custom widget for displaying full details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpandedProduct(
                                  description: product.description,
                                  id: product.productCode,
                                  name: product.productName,
                                  price: product.mrp,
                                  image: product.productImage,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3, // Add shadow to the Card
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildProductImage(product.productImage),
                                  Text(
                                    product.productCode,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    product.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${product.mrp}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
