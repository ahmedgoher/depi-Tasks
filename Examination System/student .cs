using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    internal class student
    {
        private static int id = 0;
        public int ID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }

        List<Course> courses = new List<Course>();


        public student( string name, string email)
        {
            Name=name;
            Email=email;
            ID = ++id;
            courses =new List<Course>();

            
        }

        public void enrollcourse( Course course)
        { 

            if (courses.Contains(course))
            {
                return;
            }
            else
            {
             courses.Add(course);

            }
        }
        public void startexam(Exam exam)
        {
            foreach (var item in courses)
            {
               
                
                    if (item.Exams.Contains(exam))
                        exam.answer_exam();
                else
                {
                    Console.WriteLine("Not Found");
                }


            }
        }
        public void reborts()
        {
            foreach (var item in courses)
            {

                
                foreach (var item1 in item.Exams)
                {
                    Console.WriteLine("Exam title : " + item1.Title);
                    Console.WriteLine("Student name : " + Name);
                    Console.WriteLine("Course name : " + item.Title);
                    Console.WriteLine("Score :" + item1.scoure);
                    Console.WriteLine("status : " + item1.status);
                    
                }


            }
        }


    }
}
