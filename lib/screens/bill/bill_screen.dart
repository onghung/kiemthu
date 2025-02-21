import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:Trendique_TLU/constants.dart';

class BillScreen extends StatefulWidget {

  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hóa đơn",style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('/k2n2/kfkktA9ggoZ652bCM091/cart')
            .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.email)
            .where('status', isNotEqualTo: '1')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> billItems = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              itemCount: billItems.length,
              separatorBuilder: (context, index) => Divider(), // Divider between items
              itemBuilder: (context, index) => BillItemCard(
                productId: billItems[index]['id'] ?? '',
                title: billItems[index]['title'] ?? '',
                description: billItems[index]['description'] ?? '',
                pricelast: billItems[index]['pricelast'] ?? 0,
                count: billItems[index]['count'] ?? 0,
                imageUrl: billItems[index]['urlImage'] ?? '',
                status: billItems[index]['status'] ?? '',
              ),
            ),
          );
        },
      ),
    );
  }
}


class BillItemCard extends StatelessWidget {
  final String productId;
  final String title;
  final String description;
  final int pricelast;
  final int count;
  final String imageUrl;
  final String status;

  BillItemCard({
    required this.productId,
    required this.title,
    required this.description,
    required this.pricelast,
    required this.count,
    required this.imageUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String statuss = '';

    if (status == '1') {
      return Container();
    } else if (status == '2') {
      statuss = 'Chờ xử lý';
    } else if (status == '3') {
      statuss = 'Đã hoàn thành đơn hàng';
    } else {
      statuss = 'Đơn hàng đã bị hủy';
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Status: $statuss',
                        style: TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tổng: \$$pricelast',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Số lượng: $count',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

