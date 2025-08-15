
namespace Banck_System 
{ 
public class Account
{
    private static int _accountCounter = 1000; 
    public int AccountNumber { get; private set; }
    public decimal Balance { get; private set; }
    public DateTime DateOpened { get; private set; }
    public string AccountType { get; private set; } 
    public decimal InterestRate { get; private set; } 
    public decimal OverdraftLimit { get; private set; } 
    public List<string> TransactionHistory { get; private set; }

    public Account(string accountType, decimal interestRate = 0, decimal overdraftLimit = 0)
    {
        AccountNumber = ++_accountCounter;
        AccountType = accountType;
        InterestRate = interestRate;
        OverdraftLimit = overdraftLimit;
        Balance = 0;
        DateOpened = DateTime.Now;
        TransactionHistory = new List<string>();
    }

    public void Deposit(decimal amount)
    {
        if (amount > 0)
        {
            Balance += amount;
            TransactionHistory.Add($"Deposit: +{amount} | New Balance: {Balance}");
        }
    }

    public bool Withdraw(decimal amount)
    {
            decimal limit = AccountType == "Current" ? Balance + OverdraftLimit : Balance;
        if (amount > 0 && amount <= limit)
        {
            Balance -= amount;
            TransactionHistory.Add($"Withdraw: -{amount} | New Balance: {Balance}");
            return true;
        }
        return false;
    }

    public void AddInterest()
    {
        if (AccountType == "Savings" && InterestRate > 0)
        {
                decimal interest = Balance * (InterestRate / 100);
            Balance += interest;
            TransactionHistory.Add($"Interest: +{interest} | New Balance: {Balance}");
        }
    }
        public decimal CalculateMonthlyInterest()
        {
            if (AccountType == "Savings")
            {
                decimal interest = Balance * InterestRate / 100;
                Deposit(interest);
                return interest;
            }
            return 0;
        }
    }
}