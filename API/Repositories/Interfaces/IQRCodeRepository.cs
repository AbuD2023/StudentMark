using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IQRCodeRepository : IGenericRepository<QRCode>
    {
        Task<QRCode?> GetQRCodeByValueAsync(string qrCodeValue);
        Task<IEnumerable<QRCode>> GetQRCodesByDoctorAsync(int doctorId);
        Task<IEnumerable<QRCode>> GetQRCodesByScheduleAsync(int scheduleId);
        Task<IEnumerable<QRCode>> GetActiveQRCodesAsync();
        Task<bool> IsQRCodeValueUniqueAsync(string qrCodeValue);
        Task<IEnumerable<QRCode>> GetExpiredQRCodesAsync();
    }
}