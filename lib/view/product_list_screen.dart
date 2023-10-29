import 'dart:async';

import 'package:ecommerce/constants.dart';
import 'package:ecommerce/controller/notification_provider.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controller/auth_provider.dart';
import '../controller/product_list_provider.dart';
import '../controller/product_create_provider.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Completer<void> _refreshCompleter = Completer<void>();
  // Function to build a widget that displays either an image or video
  Widget buildProductImage(String imageUrl) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
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
        width: screenwidth / 2,
        height: screenHeight / 7,
        errorBuilder: (context, error, stackTrace) {
          // Display a placeholder image or an error message
          return Image.asset(
            'assets/errorImage.png',
            width: screenwidth / 2,
            height: screenHeight / 7,
          );
        },
      );
    }
  }

  void initData(BuildContext context) async {
    final productProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    await productProvider.fetchData();
  }

  Future<void> _refreshData() async {
    final productProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    await productProvider.fetchDataFromAPIOnce(); // Refresh the data
    _refreshCompleter.complete();
    _refreshCompleter = Completer<void>(); // Create a new Completer
  }

  @override
  void initState() {
    super.initState();
    initData(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final notificationProvider = context.watch<NotificationProvider>();

    // Access the ProductProvider
    final productProvider = Provider.of<ProductListProvider>(context);
    final uploadProductsProvider = Provider.of<UploadProductsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    //final productProvider = context.watch<ProductListProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              //_refreshData();
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
            Icons.logout,
            color: Colors.black,
          ),
          onPressed: () async {
            authProvider.logout();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: const Text(
          "Product listing",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          _refreshIndicatorKey.currentState?.show();
          return _refreshData();
        },
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 25,
            ),
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
            SizedBox(
              height: screenHeight / 25,
            ),
            FutureBuilder(
              future: productProvider.fetchDataFromAPIOnce(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 30,
                      width: 100,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: kDefaultRainbowColors,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  // Build the grid view using the fetched data
                  final products = snapshot.data as List<Product>;

                  return Expanded(
                    child: GridView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.8),
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
                                  SizedBox(
                                    height: screenHeight / 65,
                                  ),
                                  Text(
                                    product.productCode,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: screenHeight / 65,
                                  ),
                                  Text(
                                    product.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: screenHeight / 65,
                                  ),
                                  Text(
                                    '₹ ${product.mrp}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/noresult.png',
                          width: screenwidth,
                          height: screenHeight / 2,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Failed to load data, check your internet connection',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/noresult.png',
                        width: screenwidth,
                        height: screenHeight / 2,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load data, check your internet connection',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
