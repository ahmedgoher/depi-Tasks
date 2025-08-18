using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    internal class Course
    {
        public  static int id = 0;
        public int ID;
        public string Title { get; set; }
        public string Description { get; set; }
        public int Maximum_degree { get; set; }
        public List<Exam> Exams { get; set; }
        public Course(string title , string description,int max_degree)

        {
            ID = ++id;
            Title = title;
            Description = description;
            Maximum_degree = max_degree;
            
            Exams = new List<Exam>();

        }
         public void addexam(Exam exam)
        {
            Exams.Add(exam);
        }

    }
}
