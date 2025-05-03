using API.DTOs;
using API.Extensions;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class QRCodeController : ControllerBase
    {
        private readonly IQRCodeService _qrCodeService;
        private readonly ILectureScheduleService _scheduleService;
        private readonly IDoctorDepartmentsLevelsService _doctorService;

        public QRCodeController(
            IQRCodeService qrCodeService,
            ILectureScheduleService scheduleService,
            IDoctorDepartmentsLevelsService doctorService)
        {
            _qrCodeService = qrCodeService;
            _scheduleService = scheduleService;
            _doctorService = doctorService;
        }

        [HttpPost("generate")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GenerateQRCode([FromBody] QRCodeGenerateDto qrCodeDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // التحقق من أن الطبيب يطلب إنشاء رمز QR لمحاضرته
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any() || doctorAssignments.First().DoctorId != qrCodeDto.DoctorId)
                {
                    return Forbid();
                }

                // التحقق من أن المحاضرة تنتمي للطبيب
                var schedule = await _scheduleService.GetByIdAsync(qrCodeDto.ScheduleId);
                if (schedule == null || schedule.DoctorId != userId)
                {
                    return BadRequest(new { message = "Schedule not found or not assigned to this doctor" });
                }
            }

            // التحقق من عدم وجود رمز QR نشط لنفس المحاضرة
            var existingQRCode = await _qrCodeService.GetActiveQRCodeByScheduleAsync(qrCodeDto.ScheduleId);
            if (existingQRCode != null)
            {
                return BadRequest(new { message = "An active QR code already exists for this schedule" });
            }

            var qrCode = await _qrCodeService.GenerateQRCodeAsync(
                qrCodeDto.ScheduleId,
                qrCodeDto.DoctorId,
                qrCodeDto.ExpiryTime.TimeOfDay);

            return Ok(qrCode);
        }

        [HttpGet("active")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetActiveQRCodes()
        {
            var userId = HttpContext.GetUserId();
            var qrCodes = await _qrCodeService.GetActiveQRCodesAsync();

            // إذا كان المستخدم طبيباً، يعرض فقط رموز QR الخاصة به
            if (User.IsInRole("Doctor"))
            {
                qrCodes = qrCodes.Where(q => q.DoctorId == userId);
            }

            return Ok(qrCodes);
        }

        [HttpGet("expired")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetExpiredQRCodes()
        {
            var userId = HttpContext.GetUserId();
            var qrCodes = await _qrCodeService.GetExpiredQRCodesAsync();

            // إذا كان المستخدم طبيباً، يعرض فقط رموز QR الخاصة به
            if (User.IsInRole("Doctor"))
            {
                qrCodes = qrCodes.Where(q => q.DoctorId == userId);
            }

            return Ok(qrCodes);
        }

        [HttpPut("{id}/cancel")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> CancelQRCode(int id)
        {
            var qrCode = await _qrCodeService.GetByIdAsync(id);
            if (qrCode == null)
            {
                return NotFound(new { message = "QR code not found" });
            }

            // التحقق من أن الطبيب يطلب إلغاء رمز QR الخاص به
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                if (qrCode.DoctorId != userId)
                {
                    return Forbid();
                }
            }

            await _qrCodeService.CancelQRCodeAsync(id);
            return NoContent();
        }

        [HttpGet("schedule/{scheduleId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetQRCodeBySchedule(int scheduleId)
        {
            var userId = HttpContext.GetUserId();
            var qrCode = await _qrCodeService.GetActiveQRCodeByScheduleAsync(scheduleId);

            if (qrCode == null)
            {
                return NotFound(new { message = "No active QR code found for this schedule" });
            }

            // التحقق من أن الطبيب يطلب رمز QR الخاص به
            if (User.IsInRole("Doctor") && qrCode.DoctorId != userId)
            {
                return Forbid();
            }

            return Ok(qrCode);
        }
    }
}