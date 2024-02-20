using IDO_DataBase_API.Models;

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace IDO_DataBase_API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class ItemApi : ControllerBase
    {
        private readonly ToDoContext _dbContext;

        public ItemApi(ToDoContext dbContext)
        {
            _dbContext = dbContext;
        }


        [HttpPost("users/{userId}/getItemsIdsByPrefix")]
        public async Task<ActionResult<IEnumerable<int>>> GetItemsIdsByPrefix(int userId,ItemPrefix prefix)
        {
            if (string.IsNullOrEmpty(prefix.prefix))
            {
                return BadRequest("Prefix cannot be empty.");
            }

            var filteredItemIds = await _dbContext.Items
               .Where(item => item.userId == userId && item.title.StartsWith(prefix.prefix))
               .Select(item => item.Id)
               .ToListAsync();


            if (filteredItemIds.Any())
            {
                return Ok(filteredItemIds);
            }
            else
            {
                return NotFound($"No items found with prefix '{prefix.prefix}'.");
            }
        }




        [HttpGet("getItemsByUserId/{userId}")]
        public async Task<ActionResult<IEnumerable<Item>>> getItemsByUserId(int userId)
        {
            var userItems = await _dbContext.Items
                .Where(item => item.userId == userId)
                .ToListAsync();

            if (userItems == null || !userItems.Any())
            {
                return NotFound($"No items found for user with ID {userId}.");
            }

            return userItems;
        }



        [HttpPut("updateItemImportance/{itemId}")]
        public async Task<IActionResult> UpdateItemImportance(int itemId, int newImportance)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }

            itemToUpdate.importance = newImportance;

            try
            {
                await _dbContext.SaveChangesAsync();
                return NoContent(); // Return 204 No Content
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item importance.");
            }
        }

        [HttpPut("updateItemCategory/{itemId}")]
        public async Task<IActionResult> UpdateItemCategory(int itemId, string newCategory)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }

            itemToUpdate.category = newCategory;

            try
            {
                await _dbContext.SaveChangesAsync();
                return NoContent();
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item category.");
            }
        }

        [HttpPut("updateItemTitle/{itemId}")]
        public async Task<IActionResult> UpdateItemTitle(int itemId, string newTitle)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }

            itemToUpdate.title = newTitle;

            try
            {
                await _dbContext.SaveChangesAsync();
                return NoContent(); // Return 204 No Content
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item title.");
            }
        }


        [HttpPut("updateItemEstimated/{itemId}")]
        public async Task<IActionResult> UpdateItemEstimated(int itemId, string newEstimatedText)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }

            itemToUpdate.estimatedText = newEstimatedText;

            try
            {
                await _dbContext.SaveChangesAsync();
                return NoContent(); // Return 204 No Content
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item estimatedText.");
            }
        }




        [HttpPost("users/{userId}/createItem")]
        public async Task<ActionResult<Item>> CreateItem(int userId)
        {
            var newItem = new Item
            {
                title = "task title",
                category = "category2",
                status = 1,
                date = DateTime.Now,
                importance = 1,
                estimatedText = "NONE",
                userId = userId,
                estimated =0
            };

            _dbContext.Items.Add(newItem);
            await _dbContext.SaveChangesAsync();

            var resp = new
            {
                Status = "success",
                created = newItem
            };

            return StatusCode(201, resp);
        }



        [HttpPut("updateItemStatus/{itemId}")]
        public async Task<IActionResult> UpdateItemStatus(int itemId, int newStatus)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }

            itemToUpdate.status = newStatus;

            try
            {
                await _dbContext.SaveChangesAsync();
                return NoContent();
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item status.");
            }
        }

        [HttpPut("updateItemDate/{itemId}")]
        public async Task<IActionResult> UpdateItemDate(int itemId, newDate newDate)
        {
            var itemToUpdate = await _dbContext.Items.FindAsync(itemId);

            if (itemToUpdate == null)
            {
                return NotFound($"Item with Id {itemId} not found.");
            }
            itemToUpdate.date = newDate.newD;
            try
            {

                    await _dbContext.SaveChangesAsync();
                    return NoContent(); 
               
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, "Error updating item date.");
            }
        }

    }

}
    public class SearchItem
    {
        public int id { get; set; }
        public string title { get; set; }

        public string category { get; set; }

        public int status { get; set; }

        public DateTime date { get; set; }
        public int importance { get; set; }

        public int userId { get; set; }

        public int estimated { get; set; }
    }
    public class SelectedItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        // other properties
    }
public class CreateItemRequest
{
    public int UserId { get; set; }
}

public class ItemPrefix
{
    public string prefix { get; set; }
}

public class newDate
{
    public DateTime newD { get; set; }
}



