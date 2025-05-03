using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using System.Security.Cryptography;
using System.Text;

namespace API.Services
{
    public class QRCodeService : GenericService<QRCode>, IQRCodeService
    {
        private readonly IQRCodeRepository _qrCodeRepository;
        private readonly IAttendanceRepository _attendanceRepository;

        public QRCodeService(
            IQRCodeRepository qrCodeRepository,
            IAttendanceRepository attendanceRepository,
            IUnitOfWork unitOfWork)
            : base(qrCodeRepository, unitOfWork)
        {
            _qrCodeRepository = qrCodeRepository;
            _attendanceRepository = attendanceRepository;
        }

        public async Task<QRCode?> GetQRCodeByValueAsync(string qrCodeValue)
        {
            return await _qrCodeRepository.GetQRCodeByValueAsync(qrCodeValue);
        }

        public async Task<IEnumerable<QRCode>> GetQRCodesByDoctorAsync(int doctorId)
        {
            return await _qrCodeRepository.GetQRCodesByDoctorAsync(doctorId);
        }

        public async Task<IEnumerable<QRCode>> GetQRCodesByScheduleAsync(int scheduleId)
        {
            return await _qrCodeRepository.GetQRCodesByScheduleAsync(scheduleId);
        }

        async Task<IEnumerable<QRCode>> IQRCodeService.GetActiveQRCodesAsync()
        {
            return await _qrCodeRepository.GetActiveQRCodesAsync();
        }

        public async Task<bool> IsQRCodeValueUniqueAsync(string qrCodeValue)
        {
            return await _qrCodeRepository.IsQRCodeValueUniqueAsync(qrCodeValue);
        }

        async Task<IEnumerable<QRCode>> IQRCodeService.GetExpiredQRCodesAsync()
        {
            return await _qrCodeRepository.GetExpiredQRCodesAsync();
        }

        public async Task<IEnumerable<Attendance>> GetQRCodeAttendancesAsync(int qrCodeId)
        {
            return await _attendanceRepository.GetAttendancesByQRCodeAsync(qrCodeId);
        }

        async Task<QRCode> IQRCodeService.GenerateQRCodeAsync(int scheduleId, int doctorId, TimeSpan duration)
        {
            // Generate a unique QR code value
            string qrCodeValue;
            do
            {
                qrCodeValue = GenerateUniqueQRCodeValue();
            } while (!await IsQRCodeValueUniqueAsync(qrCodeValue));

            var qrCode = new QRCode
            {
                QRCodeValue = qrCodeValue,
                ScheduleId = scheduleId,
                DoctorId = doctorId,
                ExpiresAt = DateTime.UtcNow.Add(duration),
                IsActive = true
            };

            await _qrCodeRepository.AddAsync(qrCode);
            await _unitOfWork.SaveChangesAsync();

            return qrCode;
        }

        private string GenerateUniqueQRCodeValue()
        {
            using (var rng = new RNGCryptoServiceProvider())
            {
                var bytes = new byte[16];
                rng.GetBytes(bytes);
                return Convert.ToBase64String(bytes);
            }
        }

        async Task<QRCode> IQRCodeService.GetActiveQRCodeByScheduleAsync(int scheduleId)
        {
            var qrCodes = await _qrCodeRepository.GetQRCodesByScheduleAsync(scheduleId);
            return qrCodes.FirstOrDefault(q => q.IsActive && q.ExpiresAt > DateTime.UtcNow);
        }

        async Task<QRCode> IQRCodeService.UpdateAsync(QRCode qrCode)
        {
            var existingQRCode = await _qrCodeRepository.GetByIdAsync(qrCode.Id);
            if (existingQRCode == null)
            {
                throw new KeyNotFoundException($"QR Code with ID {qrCode.Id} not found");
            }

            existingQRCode.QRCodeValue = qrCode.QRCodeValue;
            existingQRCode.ScheduleId = qrCode.ScheduleId;
            existingQRCode.DoctorId = qrCode.DoctorId;
            existingQRCode.ExpiresAt = qrCode.ExpiresAt;
            existingQRCode.IsActive = qrCode.IsActive;

            _qrCodeRepository.Update(existingQRCode);
            await _unitOfWork.SaveChangesAsync();

            return existingQRCode;
        }

        async Task<QRCode> IQRCodeService.CancelQRCodeAsync(int id)
        {
            var qrCode = await _qrCodeRepository.GetByIdAsync(id);
            if (qrCode == null)
            {
                throw new KeyNotFoundException($"QR Code with ID {id} not found");
            }

            qrCode.IsActive = false;
            _qrCodeRepository.Update(qrCode);
            await _unitOfWork.SaveChangesAsync();

            return qrCode;
        }

        async Task<bool> IQRCodeService.DeleteAsync(int id)
        {
            var qrCode = await _qrCodeRepository.GetByIdAsync(id);
            if (qrCode == null)
            {
                return false;
            }

            _qrCodeRepository.Remove(qrCode);
            await _unitOfWork.SaveChangesAsync();

            return true;
        }
    }
}