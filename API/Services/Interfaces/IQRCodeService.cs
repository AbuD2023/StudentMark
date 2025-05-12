using API.Entities;

namespace API.Services.Interfaces
{
    public interface IQRCodeService
    {
        Task<QRCode> GetByIdAsync(int id);
        Task<IEnumerable<QRCode>> GetAllAsync();
        Task<IEnumerable<QRCode>> GetActiveQRCodesAsync();
        Task<IEnumerable<QRCode>> GetExpiredQRCodesAsync();
        Task<QRCode> GetActiveQRCodeByScheduleAsync(int scheduleId);
        Task<QRCode?> GetQRCodeByValueAsync(string qrCodeValue);
        Task<QRCode> GenerateQRCodeAsync(int scheduleId, int doctorId, TimeSpan expiryTime);
        Task<QRCode> UpdateAsync(QRCode qrCode);
        Task<QRCode> CancelQRCodeAsync(int id);
        Task<bool> DeleteAsync(int id);
    }
}