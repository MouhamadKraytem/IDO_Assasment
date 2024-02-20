namespace IDO_DataBase_API.Models
{
    public class Item
    {
        public int Id { get; set; }

        public string title { get; set; }

        public string category { get; set; }

        public int status { get; set; }

        public DateTime? date { get; set; }
        public int ?importance { get; set; }
        public string ? estimatedText { get; set; }
        public int userId { get; set; }

        public int ?estimated { get; set; }


        public User? User { get; set; }
    }
}
