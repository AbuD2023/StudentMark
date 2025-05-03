// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/data/services/department_service.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/presentation/screens/department_form_screen.dart';

// class DepartmentsScreen extends StatefulWidget {
//   const DepartmentsScreen({super.key});

//   @override
//   State<DepartmentsScreen> createState() => _DepartmentsScreenState();
// }

// class _DepartmentsScreenState extends State<DepartmentsScreen> {
//   late DepartmentService _departmentService;
//   List<Department> _departments = [];
//   bool _isLoading = true;
//   bool _showActiveOnly = false;

//   @override
//   void initState() {
//     super.initState();
//     _departmentService = DepartmentService(context.read<ApiService>());
//     _loadDepartments();
//   }

//   Future<void> _loadDepartments() async {
//     try {
//       setState(() => _isLoading = true);
//       final departments = _showActiveOnly
//           ? await _departmentService.getActiveDepartments()
//           : await _departmentService.getAllDepartments();
//       setState(() {
//         _departments = departments;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<void> _navigateToForm(Department? department) async {
//     final result = await Navigator.push<bool>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DepartmentFormScreen(department: department),
//       ),
//     );

//     if (result == true) {
//       _loadDepartments();
//     }
//   }

//   Future<void> _showDepartmentDetails(Department department) async {
//     final courses =
//         await _departmentService.getDepartmentCourses(department.id!);
//     final detailedDepartment =
//         await _departmentService.getDepartmentWithLevels(department.id!);
//     final students =
//         await _departmentService.getDepartmentStudents(department.id!);
//     try {
//       if (!mounted) return;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(detailedDepartment.departmentName),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (detailedDepartment.description != null)
//                   Text('الوصف: ${detailedDepartment.description}'),
//                 const SizedBox(height: 8),
//                 Text(
//                     'الحالة: ${detailedDepartment.isActive ? "نشط" : "غير نشط"}'),
//                 const SizedBox(height: 16),
//                 const Text('المستويات:',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 if (detailedDepartment.levels != null)
//                   ...detailedDepartment.levels!
//                       .map((level) => Text('- ${level.levelName}')),
//                 const SizedBox(height: 8),
//                 const Text('المقررات:',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...courses.map((course) => Text('- ${course.courseName}')),
//                 const SizedBox(height: 8),
//                 const Text('عدد الطلاب:',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text('${students.length} طالب'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('إغلاق'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<void> _toggleDepartmentStatus(Department department) async {
//     try {
//       await _departmentService.toggleDepartmentStatus(department.id!);
//       _loadDepartments();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('إدارة الأقسام'),
//         actions: [
//           IconButton(
//             icon: Icon(
//                 _showActiveOnly ? Icons.filter_list_off : Icons.filter_list),
//             onPressed: () {
//               setState(() => _showActiveOnly = !_showActiveOnly);
//               _loadDepartments();
//             },
//             tooltip:
//                 _showActiveOnly ? 'عرض جميع الأقسام' : 'عرض الأقسام النشطة فقط',
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _navigateToForm(null),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _departments.isEmpty
//               ? const Center(child: Text('لا توجد أقسام'))
//               : ListView.builder(
//                   itemCount: _departments.length,
//                   itemBuilder: (context, index) {
//                     final department = _departments[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: ListTile(
//                         title: Text(department.departmentName),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 'الحالة: ${department.isActive ? "نشط" : "غير نشط"}'),
//                             if (department.description != null)
//                               Text(
//                                 department.description!,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.info),
//                               onPressed: () =>
//                                   _showDepartmentDetails(department),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 department.isActive
//                                     ? Icons.toggle_off
//                                     : Icons.toggle_on,
//                                 color: department.isActive
//                                     ? Colors.grey
//                                     : Colors.green,
//                               ),
//                               onPressed: () =>
//                                   _toggleDepartmentStatus(department),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () => _navigateToForm(department),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () async {
//                                 final confirmed = await showDialog<bool>(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text('تأكيد الحذف'),
//                                     content: Text(
//                                         'هل أنت متأكد من حذف القسم ${department.departmentName}؟'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context, false),
//                                         child: const Text('إلغاء'),
//                                       ),
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context, true),
//                                         child: const Text('حذف'),
//                                       ),
//                                     ],
//                                   ),
//                                 );

//                                 if (confirmed == true) {
//                                   try {
//                                     await _departmentService
//                                         .deleteDepartment(department.id!);
//                                     _loadDepartments();
//                                   } catch (e) {
//                                     if (mounted) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                             content: Text(
//                                                 'حدث خطأ: ${e.toString()}')),
//                                       );
//                                     }
//                                   }
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
