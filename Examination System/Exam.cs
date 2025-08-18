using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    internal class Exam
    {
        private static int id = 0;
        public int ID { get; set; }
        public string Title { get; set; }
        public DateTime startDate { get; set; }
        public List<Question> Questions { get; set; }
        public int scoure { get; set; }
        public string status { get; set; }
        public int MaxDegree { get; set; }
        public Exam(string title,DateTime stTime,int maxdegree)
        {
            ID = ++id;
            MaxDegree =maxdegree;
            Title = title;
            startDate = stTime;
            Questions=new List<Question>();
        }
       public void addq(Question q,int degree)
        {
            q.Degree=degree;
            Questions.Add(q);
           
        }
        public void removeq(Question q) {
            if (Questions.Contains(q))
            {

                Questions.Remove(q);
            }
        }
        public void edit(MCQQuestion q,string quest,int degree,List<string> chose, string ans)
        {
            if (Questions.Contains(q)&&startDate>DateTime.Now) {
                
                    q.Text = quest;
                    q.Degree = degree;
                    q.choice = chose;
                    q.correct_answer=ans;
                
            }
                else Console.WriteLine("Error");
        }
        public void edit(TrueFalseQuestion q,string quest,int degree,bool ans)
        {
            if (Questions.Contains(q) && startDate > DateTime.Now) {

                    q.Text = quest;
                    q.Degree = degree;
                    q.correct_ans = ans;
            }
                else Console.WriteLine("Error");
        }
        public void edit(EssayQuestion q,string quest,int degree,string ans)
        {
            if (Questions.Contains(q) && startDate > DateTime.Now) {
                 
                    q.Text = quest;
                    q.Degree = degree;
                    q.text_ans= ans;
                
            }
                else Console.WriteLine("Error");
        }
       
        public void display()
        {
            int total=0;
            foreach (var item in Questions)
            {
                item.Display();
                total += item.Degree;
                Console.WriteLine("The Total Degree Now of exam : " + total);
                if (total > MaxDegree)
                {
                    throw new Exception("overload degree");
                }
            }
            
            Console.WriteLine(startDate);
        }
        public void answer_exam()
        {
            int total=0;
            int correctDegree = 0;
            Console.WriteLine(startDate);
            foreach (var item in Questions)
            {
                item.Solve();
                total += item.Degree;
               correctDegree += item.TrueDegree;
            }
                Console.WriteLine($"The Total Degree of exam :{correctDegree} / {total}" );
            scoure = correctDegree;
            if (total / 2 > correctDegree)
            {
                status = "failed";
                Console.WriteLine(status);

            }
            else
            {
                status = "passed";
                Console.WriteLine(status);
            }
        }
        

    }
}
