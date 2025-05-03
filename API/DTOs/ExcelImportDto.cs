using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class ExcelImportDto
    {
        [Required]
        public IFormFile File { get; set; }

        [Required]
        public string ImportType { get; set; } // "Students" or "Doctors"
    }

    public class ExcelImportResultDto
    {
        public int TotalRecords { get; set; }
        public int SuccessfullyImported { get; set; }
        public int FailedRecords { get; set; }
        public List<ImportErrorDto> Errors { get; set; }
        public List<ImportWarningDto> Warnings { get; set; }
    }

    public class ImportErrorDto
    {
        public int RowNumber { get; set; }
        public string ErrorMessage { get; set; }
        public string Data { get; set; }
    }

    public class ImportWarningDto
    {
        public int RowNumber { get; set; }
        public string WarningMessage { get; set; }
        public string Data { get; set; }
        public string ActionTaken { get; set; }
    }
}