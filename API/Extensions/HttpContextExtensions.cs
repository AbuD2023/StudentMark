using Microsoft.AspNetCore.Http;

namespace API.Extensions
{
    public static class HttpContextExtensions
    {
        public static int GetUserId(this HttpContext context)
        {
            if (context.Items.TryGetValue("UserId", out var userId))
            {
                return (int)userId;
            }
            throw new UnauthorizedAccessException("User ID not found in context");
        }

        public static bool TryGetUserId(this HttpContext context, out int userId)
        {
            if (context.Items.TryGetValue("UserId", out var value))
            {
                userId = (int)value;
                return true;
            }
            userId = 0;
            return false;
        }
    }
}