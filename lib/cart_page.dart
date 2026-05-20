import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // READ
  Future<void> fetchCartItems() async {
    final data = await supabase.from('cart_items').select();

    setState(() {
      cartItems = List<Map<String, dynamic>>.from(data);
    });
  }

  // CREATE
  Future<void> addToCart(
    String name,
    String image,
  ) async {
    await supabase.from('cart_items').insert({
      'name': name,
      'image': image,
      'quantity': 1,
    });

    fetchCartItems();
  }

  // UPDATE +
  Future<void> increaseQuantity(int id, int quantity) async {
    await supabase
        .from('cart_items')
        .update({'quantity': quantity + 1})
        .eq('id', id);

    fetchCartItems();
  }

  // UPDATE -
  Future<void> decreaseQuantity(int id, int quantity) async {
    if (quantity > 1) {
      await supabase
          .from('cart_items')
          .update({'quantity': quantity - 1})
          .eq('id', id);
    } else {
      await deleteItem(id);
    }

    fetchCartItems();
  }

  // DELETE
  Future<void> deleteItem(int id) async {
    await supabase
        .from('cart_items')
        .delete()
        .eq('id', id);

    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Cart Page"),
      ),

      body: cartItems.isEmpty
          ? const Center(
              child: Text("Cart is Empty"),
            )
            
          : ListView.builder(
              itemCount: cartItems.length,

              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    leading:
                        item['image'].toString().startsWith('http')
                        ? Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),

                    title: Text(item['name']),

                    subtitle: Text(
                      "Quantity: ${item['quantity']}",
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          onPressed: () {
                            decreaseQuantity(
                              item['id'],
                              item['quantity'],
                            );
                          },
                          icon: const Icon(Icons.remove),
                        ),

                        IconButton(
                          onPressed: () {
                            increaseQuantity(
                              item['id'],
                              item['quantity'],
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),

                        IconButton(
                          onPressed: () {
                            deleteItem(item['id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}