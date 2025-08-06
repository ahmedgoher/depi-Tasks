using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace taskc_one
{
    internal class BankAccount
    {
        public const string BankCode = "BNK001";
        public readonly DateTime CreatedDate;

        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private double _balance;

        public string FullName
        {
            get
            { return _fullName; }
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("Full Name cannot be empty.");
                _fullName = value;

            }
        }
        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (value.Length != 14)
                    throw new ArgumentException("National ID must be exactly 14 digits.");
                _nationalID = value;
            }
        }
        public string PhoneNumber
        {
            get { return _phoneNumber; }
            set
            {
                if (value != null && value.StartsWith("01") && value.Length == 11)
                    _phoneNumber = value;
                else
                    throw new ArgumentException("Phone number must start with '01' and be 11 digits.");
            }
        }
        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }
        public double Balance
        {
            get { return _balance; }
            set
            {
                if (value >= 0)
                    _balance = value;
                else
                    throw new ArgumentException("Balance cannot be negative.");
            }
        }
        public BankAccount()
        {
            CreatedDate = DateTime.Now;
            _accountNumber = new Random().Next(1000, 9999);
            FullName = "Default Name";
            NationalID = "00000000000000";
            PhoneNumber = "01000000000";
            Address = "Default Address";
            Balance = 0;
        }
        public BankAccount(string fullName, string nationalID, string phoneNumber, string address, double balance)
        {
            CreatedDate = DateTime.Now;
            _accountNumber = new Random().Next(1000, 9999);
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = balance;
        }
        public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
            : this(fullName, nationalID, phoneNumber, address, 0) { }
        public void ShowAccountDetails()
        {
            Console.WriteLine("==== Account Info ====");
            Console.WriteLine($"Bank Code: {BankCode}");
            Console.WriteLine($"Account Number: {_accountNumber}");
            Console.WriteLine($"Full Name: {FullName}");
            Console.WriteLine($"National ID: {NationalID}");
            Console.WriteLine($"Phone: {PhoneNumber}");
            Console.WriteLine($"Address: {Address}");
            Console.WriteLine($"Balance: {Balance} EGP");
            Console.WriteLine($"Created Date: {CreatedDate}");
            Console.WriteLine("======================\n");
        }
        public bool IsValidNationalID()
        {
            return NationalID.Length == 14;
        }

        public bool IsValidPhoneNumber()
        {
            return PhoneNumber.Length == 11 && PhoneNumber.StartsWith("01");
        }

    }
}
