import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

abstract class DoctorRepository {
  Future<List<Doctor>> getAllDoctorAssignments();
  Future<List<Doctor>> getActiveDoctorAssignments();
  Future<Doctor> getDoctorAssignmentById(int id);
  Future<List<Doctor>> getAssignmentsByDoctor(int doctorId);
  Future<List<Doctor>> getAssignmentsByDepartment(int departmentId);
  Future<List<Doctor>> getAssignmentsByLevel(int levelId);
  Future<Doctor> createDoctorAssignment(Doctor doctor);
  Future<void> updateDoctorAssignment(Doctor doctor);
  Future<void> deleteDoctorAssignment(int id);
  Future<void> toggleDoctorAssignmentStatus(int id);
  Future<List<User>> getAllDoctorUsers();
}
