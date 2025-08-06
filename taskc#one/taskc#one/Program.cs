namespace taskc_one
{
    internal class Program
    {
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount(
            fullName: "Ahmed Goher",
            nationalID: "12345678901234",
            phoneNumber: "01012345678",
            address: "Cairo",
            balance: 5000
        );
            BankAccount account2 = new BankAccount(
            fullName: "khaled Morsi",
            nationalID: "98765432101234",
            phoneNumber: "01198765432",
            address: "Alexandria"
        );
            account1.ShowAccountDetails();
            account2.ShowAccountDetails();
        }
    }
}
