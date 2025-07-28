namespace simple_calc
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
           bool exit = false;
           bool exitop = false;
            while (!exit) 
            {
                Console.Write("Input the first number: ");
                double num1 = double.Parse(Console.ReadLine());
                Console.Write("Input the second number:");
                double num2 = double.Parse(Console.ReadLine());
                do
                {
                    double result;
                Console.WriteLine("What do you want to do with those numbers?\r\n" +
                    "[A]dd\r\n" +
                    "[S]ubtract\r\n" +
                    "[M]ultiply\r\n");
                string choose =Console.ReadLine().ToLower();
               
                    switch (choose)
                    {
                        case "a":
                            result = num1 + num2;
                            Console.WriteLine($"the resultis {result}");
                            exitop = false;
                            
                            break;

                        case "s":
                            try
                            {
                                result = num1 / num2;
                                Console.WriteLine($"the resultis {result}");
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine("Error!!!");
                            }
                            exitop = false;
                           
                            break;

                        case "m":
                            result = num1 * num2;
                            Console.WriteLine($"the resultis {result}");
                            exitop = false;
                            break;
                        default:
                            Console.WriteLine("wrong choose");
                            exitop = true;
                            break;
                    }
                }while (exitop);
                Console.WriteLine("Do you woant to try another numbers? (Y/N)");
                string again = Console.ReadLine();
                if(again != "Y"&& again != "y")
                {
                    exit = true;
                    Console.WriteLine("K");
                }
                else exit=false;

            }

        }
    }
}
