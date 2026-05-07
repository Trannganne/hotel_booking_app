import 'package:flutter/material.dart';

class TongQuanScreen extends StatelessWidget {
  const TongQuanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0077FF),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mở form sửa Thông tin Khách sạn'),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.business, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan hệ thống',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

                double childAspectRatio = constraints.maxWidth < 600
                    ? 1.1
                    : 1.5;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                  children: [
                    _buildStatCard(
                      title: 'Tổng doanh thu',
                      value: '15.500.000đ',
                      icon: Icons.monetization_on,
                      color: Colors.green,
                    ),
                    _buildStatCard(
                      title: 'Phòng trống',
                      value: '12',
                      icon: Icons.meeting_room,
                      color: Colors.blue,
                    ),
                    _buildStatCard(
                      title: 'Đơn trong ngày',
                      value: '08',
                      icon: Icons.today,
                      color: Colors.orange,
                    ),
                    _buildStatCard(
                      title: 'Đơn chưa duyệt',
                      value: '03',
                      icon: Icons.pending_actions,
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),
            const Text(
              'Hoạt động gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications_none),
                  ),
                  title: Text('Đơn đặt mới: DH00${index + 11}'),
                  subtitle: const Text('Phòng Deluxe - 1.200.000đ'),
                  trailing: const Text('10 phút trước'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
