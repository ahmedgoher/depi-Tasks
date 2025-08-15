using System;
using System.Collections.Generic;
using System.Security.Principal;

namespace Banck_System
{
    public class Customer
    {
        private static int _idCounter = 0;
        public int CustomerID { get; private set; }
        public string FullName { get; set; }
        public string NationalID { get; set; }
        public DateTime DateOfBirth { get; set; }
        public List<Account> Accounts { get; private set; }

        public Customer(string fullName, string nationalID, DateTime dateOfBirth)
        {
            CustomerID = ++_idCounter;
            FullName = fullName;
            NationalID = nationalID;
            DateOfBirth = dateOfBirth;
            Accounts = new List<Account>();
        }

        public void AddAccount(Account account)
        {
            Accounts.Add(account);
        }

        public decimal GetTotalBalance()
        {
            decimal total = 0;
            foreach (var acc in Accounts)
                total += acc.Balance;
            return total;
        }

        public bool CanBeRemoved()
        {
            foreach (var acc in Accounts)
                if (acc.Balance != 0) return false;
            return true;
        }
        public void EditCustomerInfo(string newName, DateTime newDob)
        {
            FullName = newName;
            DateOfBirth = newDob;
        }

    }
}