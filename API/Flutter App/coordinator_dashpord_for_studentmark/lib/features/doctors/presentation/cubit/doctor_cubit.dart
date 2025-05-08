// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/repositories/doctor_repository.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

// // States
// abstract class DoctorState extends Equatable {
//   const DoctorState();

//   @override
//   List<Object> get props => [];
// }

// class DoctorInitial extends DoctorState {}

// class DoctorLoading extends DoctorState {}

// class DoctorLoaded extends DoctorState {
//   final List<Doctor> doctors;

//   const DoctorLoaded(this.doctors);

//   @override
//   List<Object> get props => [doctors];
// }

// class DoctorError extends DoctorState {
//   final String message;

//   const DoctorError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class DoctorUsersLoaded extends DoctorState {
//   final List<User> users;

//   const DoctorUsersLoaded(this.users);

//   @override
//   List<Object> get props => [users];
// }

// // Cubit
// class DoctorCubit extends Cubit<DoctorState> {
//   final DoctorRepository _doctorRepository;

//   DoctorCubit(this._doctorRepository) : super(DoctorInitial());

//   Future<void> getAllDoctorAssignments() async {
//     try {
//       emit(DoctorLoading());
//       final doctors = await _doctorRepository.getAllDoctorAssignments();
//       emit(DoctorLoaded(doctors));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getActiveDoctorAssignments() async {
//     try {
//       emit(DoctorLoading());
//       final doctors = await _doctorRepository.getActiveDoctorAssignments();
//       emit(DoctorLoaded(doctors));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getDoctorAssignmentById(int id) async {
//     try {
//       emit(DoctorLoading());
//       final doctor = await _doctorRepository.getDoctorAssignmentById(id);
//       emit(DoctorLoaded([doctor]));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getAssignmentsByDoctor(int doctorId) async {
//     try {
//       emit(DoctorLoading());
//       final doctors = await _doctorRepository.getAssignmentsByDoctor(doctorId);
//       emit(DoctorLoaded(doctors));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getAssignmentsByDepartment(int departmentId) async {
//     try {
//       emit(DoctorLoading());
//       final doctors =
//           await _doctorRepository.getAssignmentsByDepartment(departmentId);
//       emit(DoctorLoaded(doctors));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getAssignmentsByLevel(int levelId) async {
//     try {
//       emit(DoctorLoading());
//       final doctors = await _doctorRepository.getAssignmentsByLevel(levelId);
//       emit(DoctorLoaded(doctors));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> createDoctorAssignment(Doctor doctor) async {
//     try {
//       emit(DoctorLoading());
//       await _doctorRepository.createDoctorAssignment(doctor);
//       await getAllDoctorAssignments();
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> updateDoctorAssignment(Doctor doctor) async {
//     try {
//       emit(DoctorLoading());
//       await _doctorRepository.updateDoctorAssignment(doctor);
//       await getAllDoctorAssignments();
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> deleteDoctorAssignment(int id) async {
//     try {
//       emit(DoctorLoading());
//       await _doctorRepository.deleteDoctorAssignment(id);
//       await getAllDoctorAssignments();
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> toggleDoctorAssignmentStatus(int id) async {
//     try {
//       emit(DoctorLoading());
//       await _doctorRepository.toggleDoctorAssignmentStatus(id);
//       await getAllDoctorAssignments();
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }

//   Future<void> getAllDoctorUsers() async {
//     try {
//       emit(DoctorLoading());
//       final users = await _doctorRepository.getAllDoctorUsers();
//       emit(DoctorUsersLoaded(users));
//     } catch (e) {
//       emit(DoctorError(e.toString()));
//     }
//   }
// }
