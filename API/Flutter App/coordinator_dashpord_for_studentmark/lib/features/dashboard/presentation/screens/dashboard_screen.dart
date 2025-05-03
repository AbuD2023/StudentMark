// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/presentation/screens/departments_screen.dart';

// import '../../../../core/services/auth_service.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('لوحة التحكم'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // TODO: Implement notifications
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               // TODO: Implement profile
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               final authService =
//                   Provider.of<AuthService>(context, listen: false);
//               authService.logout();
//               Navigator.pushReplacementNamed(context, '/login');
//               // TODO: Implement profile
//             },
//           ),
//         ],
//       ),
//       body: ResponsiveRowColumn(
//         rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         rowCrossAxisAlignment: CrossAxisAlignment.start,
//         columnMainAxisAlignment: MainAxisAlignment.start,
//         columnCrossAxisAlignment: CrossAxisAlignment.stretch,
//         layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
//             ? ResponsiveRowColumnType.ROW
//             : ResponsiveRowColumnType.COLUMN,
//         children: [
//           ResponsiveRowColumnItem(
//             rowFlex: 2,
//             child: _buildStatisticsCard(),
//           ),
//           ResponsiveRowColumnItem(
//             rowFlex: 1,
//             child: _buildQuickActionsCard(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatisticsCard() {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'الإحصائيات',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             GridView.count(
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//               children: [
//                 _buildStatItem('الطلاب', '150', Icons.people),
//                 _buildStatItem('المحاضرين', '20', Icons.person),
//                 _buildStatItem('المواد', '30', Icons.book),
//                 _buildStatItem('الأقسام', '5', Icons.category),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionsCard(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'إجراءات سريعة',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildQuickActionButton(
//               'إدارة الأقسام',
//               Icons.category,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const DepartmentsScreen(),
//                   ),
//                 );
//               },
//             ),
//             _buildQuickActionButton('إضافة طالب', Icons.person_add),
//             _buildQuickActionButton('إضافة محاضر', Icons.person_add),
//             _buildQuickActionButton('إضافة مادة', Icons.add),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String title, String value, IconData icon) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionButton(
//     String title,
//     IconData icon, {
//     VoidCallback? onPressed,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon),
//         label: Text(title),
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 48),
//         ),
//       ),
//     );
//   }
// }
