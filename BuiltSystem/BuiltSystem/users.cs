using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuiltSystem
{
    internal class users
    {
        int _userID;
        string _userName;
        string _password;
        
        public int UserID {
            get { return _userID; } 
            set {
                
                _userID = value;
            }
        }
        public string UserName {
            get { return _userName; }
            set {
                if (string.IsNullOrEmpty(value))
                    Console.WriteLine("Invalied");
                else
                    _userName = value;
            } 
        }
        public string Password {
            get { return _password; } 
            set {
                if (string.IsNullOrEmpty(value))
                    Console.WriteLine("Invalied");
                else
                    _password = value;
            }
        }

    }
}
