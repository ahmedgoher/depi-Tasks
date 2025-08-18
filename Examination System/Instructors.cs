using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    internal class Instructors
    {
        private static int id = 0;
        public int ID { get; set; }
        public string Name { get; set; }
        public string Specialization { get; set; }
        public List<Course> course { get; set; }


        public Instructors( string name, string specialization )

        {
            ID=id++;
            Name=name;
            Specialization=specialization;
            course = new List<Course>();
        }

    }
}
