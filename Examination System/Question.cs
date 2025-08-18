using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    abstract class Question
    {
        public static int id = 0;
        public int Id { get; set; }

        public string Text { get; set; }
        public int Degree { get; set; }
        public int TrueDegree { get; set; }
        public string QuestionType { get; set; }
        public abstract void Display();
        public abstract void Solve();

    }
    class MCQQuestion : Question
    {
        public List<string> choice { get; set; }
        public string correct_answer { get; set; }
        public MCQQuestion()
        {
            Id = ++id;
            choice = new List<string>();
            QuestionType = "MCQ";
        }
        public override void Display()
        {
            Console.WriteLine($"[MCQ] {Text} (Degree: {Degree})");
            for (int i = 0; i < choice.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {choice[i]}");

            }

        }

        public override void Solve()
        {
           Display();
            Console.Write("Enter Answer(1/2/3/4): ");
            string res=Console.ReadLine().ToUpper();
            
            
            if (res == correct_answer) {
             
                TrueDegree = Degree;
            
            }
        }
    }
        class TrueFalseQuestion : Question
        {
            public bool correct_ans { get; set; }
            public TrueFalseQuestion()
            {
                Id = ++id;
                QuestionType = "TrueFalse";
            }
            public override void Display()
            {
                Console.WriteLine($"[T/F] {Text} (Degree: {Degree})");
                Console.WriteLine("1. True");
                Console.WriteLine("2. False");

            }

        public override void Solve()
        {
            Display();
            Console.Write("Enter Answer((true/false)): ");
            bool res =bool.Parse( Console.ReadLine().ToUpper());

            if (res == correct_ans)
            {

                TrueDegree = Degree;

            }
        }
    }
        class EssayQuestion : Question
        {
            public string text_ans { get; set; }
            public EssayQuestion()
            {
                Id = ++id;
                QuestionType = "Essay";
            }
            public override void Display() {
                Console.WriteLine($"[Essay] {Text} (Degree: {Degree})");
            }

        public override void Solve()
        {
            Display();
            Console.Write("Enter Answer: ");
            string res = Console.ReadLine().ToUpper();
            if (!string.IsNullOrEmpty(res))
            {

                TrueDegree = Degree;

            }
        }
    }

}
