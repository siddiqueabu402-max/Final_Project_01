import 'package:final_project/cart_page.dart';
import 'package:final_project/converter_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  // ADD TO CART
  Future<void> addToCart({
    required String name,
    required String image,
    required int price,
  }) async {
    try {
      final existingItems = await supabase
          .from('cart_items')
          .select()
          .eq('name', name);

      if (existingItems.isNotEmpty) {
        final item = existingItems.first;

        await supabase
            .from('cart_items')
            .update({'quantity': item['quantity'] + 1})
            .eq('id', item['id']);
      } else {
        await supabase.from('cart_items').insert({
          'name': name,
          'image': image,
          'price': price,
          'quantity': 1,
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$name added to cart")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,

        // centerTitle: true,
        title: Text(
          "Pets.co",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          // CART PAGE
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },

            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          ),

          // LOGIN / LOGOUT
          InkWell(
            onTap: () async {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConverterPage(),
                  ),
                );
              } else {
                await supabase.auth.signOut();

                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logout Successful")),
                );
              }
            },

            child: Row(
              children: [
                Icon(
                  user == null ? Icons.login : Icons.logout,
                  color: Colors.white,
                ),

                const SizedBox(width: 5),

                Text(
                  user == null ? "Login" : "Logout",
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),

      // DRAWER
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 238, 238, 243),

        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
              ),

              accountName: Text(
                "Petslover",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              accountEmail: Text(
                "petslover@example.com",
                style: TextStyle(color: Colors.black),
              ),

              decoration: BoxDecoration(color: Colors.blueGrey),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text(
                "My Pets",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.call),
              title: const Text(
                "Contact",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // TITLE
            Text(
              "Welcome to Pets.co",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            Text(
              'Choice Your Pets',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 104, 77, 123),
              ),
            ),

            const SizedBox(height: 30),

            // CATS TITLE
            Padding(
              padding: const EdgeInsets.all(8.0),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Cats : Cute and Cuddly!",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            Row(
              children: [
                // CAT 1
                Expanded(
                  child: Column(
                    children: [
                      Image.asset(
                        'images/randomi.jpg',
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Persian Cat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),

                        onPressed: () async {
                          await addToCart(
                            name: "Persian Cat",
                            image: "images/randomi.jpg",
                            price: 1200,
                          );
                        },

                        child: const Text("Buy Now"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // CAT 2
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1765171931404-4c019bfd6c8f?q=80&w=1074&auto=format&fit=crop',
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Japanese Bobtail",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),

                        onPressed: () async {
                          await addToCart(
                            name: "Japanese Bobtail",
                            image:
                                'https://images.unsplash.com/photo-1765171931404-4c019bfd6c8f?q=80&w=1074&auto=format&fit=crop',
                            price: 1500,
                          );
                        },

                        child: const Text("Buy Now"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // CAT 3
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1676734661920-12210a474929?q=80&w=1170&auto=format&fit=crop',
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "British Shorthair",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),

                        onPressed: () async {
                          await addToCart(
                            name: "British Shorthair",
                            image:
                                'https://images.unsplash.com/photo-1676734661920-12210a474929?q=80&w=1170&auto=format&fit=crop',
                            price: 1700,
                          );
                        },

                        child: const Text("Buy Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dogs: Loyal and Loving!',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    height: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1523480717984-24cba35ae1ef?q=80&w=1170&auto=format&fit=crop',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Golden Retriever',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1539641388297-277284b9ba67?q=80&w=1170&auto=format&fit=crop',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'German Shepherd',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=1074&auto=format&fit=crop',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Beagle',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Birds: Colorful and Chirpy!',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    height: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1763306887571-2e2e3dcd9f32?q=80&w=1025&auto=format&fit=crop',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Cockatiels',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.pexels.com/photos/6398824/pexels-photo-6398824.jpeg',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Canaries',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        'https://images.pexels.com/photos/20807682/pexels-photo-20807682.jpeg',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Lovebirds',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
