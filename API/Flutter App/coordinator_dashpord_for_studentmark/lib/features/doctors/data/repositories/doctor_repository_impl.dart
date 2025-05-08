import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/data/services/doctor_service.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorService _doctorService;

  DoctorRepositoryImpl(this._doctorService);

  @override
  Future<List<Doctor>> getAllDoctorAssignments() async {
    return await _doctorService.getAllDoctorAssignments();
  }

  @override
  Future<List<Doctor>> getActiveDoctorAssignments() async {
    return await _doctorService.getActiveDoctorAssignments();
  }

  @override
  Future<Doctor> getDoctorAssignmentById(int id) async {
    return await _doctorService.getDoctorAssignmentById(id);
  }

  @override
  Future<List<Doctor>> getAssignmentsByDoctor(int doctorId) async {
    return await _doctorService.getAssignmentsByDoctor(doctorId);
  }

  @override
  Future<List<Doctor>> getAssignmentsByDepartment(int departmentId) async {
    return await _doctorService.getAssignmentsByDepartment(departmentId);
  }

  @override
  Future<List<Doctor>> getAssignmentsByLevel(int levelId) async {
    return await _doctorService.getAssignmentsByLevel(levelId);
  }

  @override
  Future<Doctor> createDoctorAssignment(Doctor doctor) async {
    return await _doctorService.createDoctorAssignment(doctor);
  }

  @override
  Future<void> updateDoctorAssignment(Doctor doctor) async {
    await _doctorService.updateDoctorAssignment(doctor);
  }

  @override
  Future<void> deleteDoctorAssignment(int id) async {
    await _doctorService.deleteDoctorAssignment(id);
  }

  @override
  Future<void> toggleDoctorAssignmentStatus(int id) async {
    await _doctorService.toggleDoctorAssignmentStatus(id);
  }

  @override
  Future<List<User>> getAllDoctorUsers() async {
    return await _doctorService.getAllDoctorUsers();
  }
}
