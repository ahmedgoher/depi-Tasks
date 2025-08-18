namespace Examination_System
{
    internal class Program
    {
        static void Main(string[] args)


        {

            Instructors instructors1 = new Instructors("kareem ",".net");

            student student1 = new student( "Ahmed goher  ","ahmedgoher@gmail.com" );



            Course course1 = new Course("oop"," ",15);



            student1.enrollcourse(course1);



            MCQQuestion mq = new MCQQuestion
            {
                Text = "Which of the following is NOT a data type in C#?",
                choice = new List<string> { " int", " string", " float", " character" },
                correct_answer = "4" 
            };

            MCQQuestion mq1 = new MCQQuestion
            {
                Text = "Which keyword is used in C# to inherit from a base class?",
                choice = new List<string> { " this", " base", " extends", " : " },
                correct_answer = "4"
            };

            MCQQuestion mq2 = new MCQQuestion
            {
                Text = "Which of the following allows creating multiple methods with the same name but different parameters?",
                choice = new List<string> { " Overloading", " Overriding", " Hiding", " Abstraction" },
                correct_answer = "1"
            };


            TrueFalseQuestion trueFalseQuestion = new TrueFalseQuestion
            {
                Text = "In C#, structs can implement interfaces.",
                correct_ans = true
            };

            EssayQuestion essayQuestion = new EssayQuestion
            {
                Text = "What is Polymorphism in C#? Give an example.",
                text_ans = "Polymorphism allows objects to take many forms. Example: a base class Shape with a Draw() method, and derived classes Circle/Rectangle overriding Draw()."
            };




            Exam ex = new Exam(" C# - OOP ", DateTime.Now, 15);

            
            ex.addq(mq,3);
            ex.addq(mq1, 3);
            ex.addq(mq2, 3);
            ex.addq(trueFalseQuestion, 3);
            ex.addq(essayQuestion, 3);


            course1.addexam(ex);
            student1.startexam(ex);
            Console.WriteLine("======================================");

            student1.reborts();

            Console.ReadLine();
        }
    }
}
