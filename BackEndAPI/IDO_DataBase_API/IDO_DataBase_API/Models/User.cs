namespace IDO_DataBase_API.Models

{
    public class User
    {
        public int id { get; set; }

        public string email { get; set; }

        public string password { get; set; }

        public string img { get; set; }

        public ICollection<Item> Items { get; set; }
    }
}
