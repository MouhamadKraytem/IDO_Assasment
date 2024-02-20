using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IDO_DataBase_API.Migrations
{
    public partial class ItemUpdates : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "importanceText",
                table: "Items",
                newName: "estimatedText");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "estimatedText",
                table: "Items",
                newName: "importanceText");
        }
    }
}
