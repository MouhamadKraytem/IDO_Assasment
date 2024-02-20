using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IDO_DataBase_API.Migrations
{
    public partial class ItemUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "importanceText",
                table: "Items",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "importanceText",
                table: "Items");
        }
    }
}
