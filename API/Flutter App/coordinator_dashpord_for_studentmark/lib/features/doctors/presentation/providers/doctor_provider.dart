import 'package:flutter/foundation.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/data/services/doctor_service.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorRepository _doctorRepository;
  final DoctorService _doctorService;
  List<Doctor> _doctors = [];
  List<User> _doctorUsers = [];
  List<Department> _departments = [];
  List<Level> _levels = [];
  bool _isLoading = false;
  String _error = '';

  DoctorProvider(this._doctorRepository, this._doctorService);

  List<Doctor> get doctors => _doctors;
  List<User> get doctorUsers => _doctorUsers;
  List<Department> get departments => _departments;
  List<Level> get levels => _levels;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> getAllDoctorAssignments() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctors = await _doctorRepository.getAllDoctorAssignments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getActiveDoctorAssignments() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctors = await _doctorRepository.getActiveDoctorAssignments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDoctorAssignmentById(int id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final doctor = await _doctorRepository.getDoctorAssignmentById(id);
      _doctors = [doctor];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAssignmentsByDoctor(int doctorId) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctors = await _doctorRepository.getAssignmentsByDoctor(doctorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAssignmentsByDepartment(int departmentId) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctors =
          await _doctorRepository.getAssignmentsByDepartment(departmentId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAssignmentsByLevel(int levelId) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctors = await _doctorRepository.getAssignmentsByLevel(levelId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createDoctorAssignment(Doctor doctor) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _doctorRepository.createDoctorAssignment(doctor);
      await getAllDoctorAssignments();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDoctorAssignment(Doctor doctor) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _doctorRepository.updateDoctorAssignment(doctor);
      await getAllDoctorAssignments();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDoctorAssignment(int id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _doctorRepository.deleteDoctorAssignment(id);
      await getAllDoctorAssignments();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDoctorAssignmentStatus(int id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _doctorRepository.toggleDoctorAssignmentStatus(id);
      await getAllDoctorAssignments();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllDoctorUsers() async {
    try {
      _isLoading = true;
      _error = '';
      // notifyListeners();

      _doctorUsers = await _doctorRepository.getAllDoctorUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllDepartments() async {
    _departments = await _doctorService.getAllDepartments();
    notifyListeners();
  }

  Future<List<Level>> getLevelsByDepartment(int departmentId) async {
    _levels = await _doctorService.getLevelsByDepartment(departmentId);
    notifyListeners();
    return _levels;
  }

  Future<String> createDoctorUser(User user) async {
    final meesage = await _doctorService.createDoctorUser(user);
    // _doctorUsers.add(createdUser);
    // notifyListeners();
    return meesage;
  }

  Future<List<User>> getUnassignedDoctorUsers() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _doctorUsers = await _doctorService.getUnassignedDoctorUsers();
      _isLoading = false;
      notifyListeners();
      return _doctorUsers;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
