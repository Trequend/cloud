using System.ComponentModel.DataAnnotations;
using CloudApi.Validation;

namespace CloudApi.V1.Dto;

public class ChangeAvatarDto
{
    [Required(ErrorMessage = "Required field")]
    [FormFileValidator(ContentType = "image/png, image/jpeg")]
    public IFormFile File { get; set; } = null!;
}
