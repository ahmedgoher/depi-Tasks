using System;
using System.Collections.Generic;

namespace Banck_System
{
    internal class Program
    {
        static List<Customer> customers = new List<Customer>();

        static void Main(string[] args)
        {
            bool start = true;

            do
            {
                Console.WriteLine("\nChoose number (1/2/3/4):");
                Console.WriteLine("1 - Add Account");
                Console.WriteLine("2 - Remove Account");
                Console.WriteLine("3 - Edit Account");
                Console.WriteLine("4 - Show All Accounts");
                Console.WriteLine("0 - Exit");

                var op = Console.ReadLine();

                switch (op)
                {
                    case "1":
                        AddAccount();
                        break;

                    case "2":
                        RemoveAccount();
                        break;

                    case "3":
                        EditAccount();
                        break;

                    case "4":
                        ShowAllAccounts();
                        break;

                    case "0":
                        start = false;
                        break;

                    default:
                        Console.WriteLine("Invalid choice.");
                        break;
                }

            } while (start);
        }

        static void AddAccount()
        {
            Console.Write("Enter Name: ");
            string name = Console.ReadLine();

            Console.Write("Enter National ID: ");
            string nationalID = Console.ReadLine();

            Console.Write("Enter Balance: ");
            decimal balance = decimal.Parse(Console.ReadLine());

            Console.Write("Enter Birthdate (yyyy-mm-dd): ");
            DateTime birthdate = DateTime.Parse(Console.ReadLine());

            customers.Add(new Customer(name, nationalID, birthdate));
            Console.WriteLine("Account added successfully!");
        }

        static void RemoveAccount()
        {
            Console.Write("Enter National ID to remove: ");
            string id = Console.ReadLine();

            var customer = customers.Find(c => c.NationalID == id);
            if (customer.CanBeRemoved())
            {
                customers.Remove(customer);
                Console.WriteLine("Account removed successfully.");
            }
            else
            {
                Console.WriteLine("Cannot remove customer. Accounts have non-zero balance.");
            }

        }

        static void EditAccount()
        {
            Console.Write("Enter National ID to edit: ");
            string id = Console.ReadLine();

            var customer = customers.Find(c => c.NationalID == id);
            if (customer != null)
            {
                Console.Write("Enter new name: ");
                customer.FullName = Console.ReadLine();

                Console.Write("Enter new birthdate (yyyy-mm-dd): ");
                customer.EditCustomerInfo(customer.FullName, DateTime.Parse(Console.ReadLine()));

                Console.WriteLine("Account updated successfully.");
            }
            else
            {
                Console.WriteLine("Account not found.");
            }
        }

        static void ShowAllAccounts()
        {
            foreach (var c in customers)
            {
                Console.WriteLine($"Name: {c.FullName} | National ID: {c.NationalID} | Total Balance: {c.GetTotalBalance()}");
            }
        }
    }
}
