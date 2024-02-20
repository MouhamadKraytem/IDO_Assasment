using IDO_DataBase_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
namespace IDO_DataBase_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserApi : ControllerBase
    {
        private readonly ToDoContext _dbContext;

        public UserApi(ToDoContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> getAllUsers()
        {
            if (_dbContext.Users == null)
            {
                return NotFound();
            }
            return await _dbContext.Users.ToListAsync();
        }


        [HttpPost("Login")]
        public async Task<ActionResult<Item>> Login(UserLoginRequest request)
        {
            var user = await _dbContext.Users
                .FirstOrDefaultAsync(u => u.email == request.Email && u.password == request.Password);

            if (user == null)
            {
                return NotFound(new { Status = "error", Message = "User not found." });
            }


            var userResponse = new
            {
                Status = "success",
                User = new
                {
                    Id = user.id,
                    Email = user.email,
                    img = user.img,

                }
            };

            return Ok(userResponse);
        }


    }

}
    public class UserLoginRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }



