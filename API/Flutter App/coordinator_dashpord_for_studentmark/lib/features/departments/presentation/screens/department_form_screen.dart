// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/data/services/department_service.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';

// class DepartmentFormScreen extends StatefulWidget {
//   final Department? department;

//   const DepartmentFormScreen({super.key, this.department});

//   @override
//   State<DepartmentFormScreen> createState() => _DepartmentFormScreenState();
// }

// class _DepartmentFormScreenState extends State<DepartmentFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late final DepartmentService _departmentService;
//   late final TextEditingController _nameController;
//   // late final TextEditingController _codeController;
//   late final TextEditingController _descriptionController;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _departmentService = DepartmentService(context.read<ApiService>());
//     _nameController =
//         TextEditingController(text: widget.department?.departmentName);
//     _descriptionController =
//         TextEditingController(text: widget.department?.description);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     // _codeController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveDepartment() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final department = Department(
//         id: widget.department?.id ?? 0,
//         departmentName: _nameController.text,
//         description: _descriptionController.text,
//         isActive: true,

//         // createdAt: widget.department?.createdAt ?? DateTime.now(),
//         // updatedAt: DateTime.now(),
//       );

//       if (widget.department == null) {
//         await _departmentService.createDepartment(department);
//       } else {
//         await _departmentService.updateDepartment(department);
//       }

//       if (mounted) {
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Text(widget.department == null ? 'إضافة قسم جديد' : 'تعديل القسم'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'اسم القسم',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال اسم القسم';
//                 }
//                 return null;
//               },
//             ),
//             // const SizedBox(height: 16),
//             // TextFormField(
//             //   controller: _codeController,
//             //   decoration: const InputDecoration(
//             //     labelText: 'رمز القسم',
//             //     border: OutlineInputBorder(),
//             //   ),
//             //   validator: (value) {
//             //     if (value == null || value.isEmpty) {
//             //       return 'الرجاء إدخال رمز القسم';
//             //     }
//             //     return null;
//             //   },
//             // ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'وصف القسم',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _saveDepartment,
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : Text(widget.department == null ? 'إضافة' : 'حفظ التغييرات'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
