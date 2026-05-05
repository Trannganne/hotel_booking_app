import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:fl_chart/fl_chart.dart';

class TongQuanScreen extends StatelessWidget {
  const TongQuanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "TRUNG TÂM THỐNG KÊ",
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Xử lý thông báo
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3 Card Thống kê trên cùng
            Row(
              children: [
                Expanded(
                  child: _buildTopStatCard('TỔNG SỐ KHÁCH SẠN', '1,200', '+5%'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTopStatCard('TỔNG SỐ PHÒNG', '15,000', '+8%'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTopStatCard(
                    'TỔNG DOANH THU',
                    '45 TỶ VND',
                    '+12%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Biểu đồ Doanh thu theo tháng
            _buildSectionCard(
              title: 'DOANH THU THEO THÁNG (4 THÁNG QUA)',
              child: _buildBarChart(),
            ),
            const SizedBox(height: 12),

            // Biểu đồ Tròn
            _buildSectionCard(
              title: 'TỔNG ĐƠN ĐẶT THEO KHU VỰC (TP.HCM, HN, DN)',
              child: _buildPieChart(),
            ),
            const SizedBox(height: 12),

            // Danh sách Top 5
            _buildSectionCard(
              title: 'TOP 5 KHÁCH SẠN DOANH THU CAO NHẤT',
              child: _buildTop5List(),
            ),
            const SizedBox(height: 16), // Padding dưới cùng
          ],
        ),
      ),
    );
  }

  // Widget cho 3 thẻ thống kê trên cùng
  Widget _buildTopStatCard(String title, String value, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '($percentage)',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Khung viền chung cho các phần bên dưới
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Biểu đồ cột (Giả lập bằng fl_chart)
  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(fontSize: 10);
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '1 Tháng';
                      break;
                    case 1:
                      text = '2 Tháng';
                      break;
                    case 2:
                      text = '3 Tháng';
                      break;
                    case 3:
                      text = '4 Tháng';
                      break;
                    default:
                      text = '';
                  }
                  return SideTitleWidget(
                    meta: meta, // Sửa ở dòng này
                    child: Text(text, style: style),
                  );
                },
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 200,
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 300, 480),
            _makeGroupData(1, 600, 400),
            _makeGroupData(2, 450, 850),
            _makeGroupData(3, 880, 620),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF4A90E2),
          width: 14,
          borderRadius: BorderRadius.zero,
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFF5A6270),
          width: 14,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }

  // Biểu đồ tròn (Giả lập bằng fl_chart)
  Widget _buildPieChart() {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF4A90E2),
                    value: 40,
                    title: '',
                    radius: 40,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFE24A4A),
                    value: 30,
                    title: '',
                    radius: 40,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFF5A623),
                    value: 30,
                    title: '',
                    radius: 40,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(const Color(0xFF4A90E2), 'TP.HCM'),
                const SizedBox(height: 8),
                _buildLegendItem(const Color(0xFFE24A4A), 'HN'),
                const SizedBox(height: 8),
                _buildLegendItem(const Color(0xFFF5A623), 'DN'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Danh sách Top 5
  Widget _buildTop5List() {
    final List<Map<String, String>> top5Data = [
      {'rank': '1', 'name': 'Ocean Suite (Đà Nẵng)', 'revenue': '45 TỶ VND'},
      {'rank': '2', 'name': 'Ocean Suite (Đà Nẵng)', 'revenue': '45 TỶ VND'},
      {'rank': '3', 'name': 'Vinpearl (Nha Trang)', 'revenue': '25 TỶ VND'},
      {'rank': '4', 'name': 'Sunrite (Đà Nẵng)', 'revenue': '10 TỶ VND'},
      {'rank': '5', 'name': 'Pooesa Mna (DN)', 'revenue': '8 TỶ VND'},
    ];

    return Column(
      children: top5Data.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;
        return Container(
          color: index.isEven ? const Color(0xFFF2F6F9) : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  data['rank']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  data['name']!,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text(
                data['revenue']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
