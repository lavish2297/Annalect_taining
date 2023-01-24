#!bin/bash
echo " My command line test"
echo "Please choose the below option"

mscreen_func(){
	login_time=$(date +"%c")
        echo "press 1 for sign up:"
        echo "press 2 for sign in:"
        echo "press 3 for exit:"
        read press

        case $press in
                1)sign_up
                        ;;
                2)sign_in
                        ;;
                3)Exit
                        ;;
        esac
}

sign_in()
{
        echo "Sign in screen"
        echo "please enter your credential"
        read -p  "enter the username:" u
        read -s -p  "enter the Password:" p
        if grep -q -w "$u,$p"* login_file.txt
       	then
		echo "Login Sucessfull"
		echo "My command  line test"
		echo "press 1 for take a test"
		echo "press 2 for view your test"
		echo "press 3 for exit"
		read press
		case $press in
			1)take_test
				;;
			2)view_test
				;;
			3)exit
				;;
		esac
	else
		echo "Wrong username or password."
		echo
		echo "------CHOOSE OTHER OPTIONS----------"
		echo "press 1 for sign up:"
		echo "press 2 for sign in:"
		echo "press 3 for exit:"
		read press
		case $press in
			1)sign_up
				;;
			2)sign_in
				;;
			3)exit
				;;
		esac
	fi
}

sign_up()
        {

        echo "sign up screen"
        read -p "Please choose your username:" u
        if grep -w -q "$u"* login_file.txt
       	then
                echo "user exist"
        else
                if test -z "$(echo -n  "$u" |tr -d 'a-zA-Z0-9')"
                then
                    read -s -p "Please choose your password:" p
                    if [ ${#p} -lt 8 ]
                    then
                        echo "Password must contain atleast 8 character"
                        read -s -p "Choose your password:" p
                    fi
               
      
	read -s -p "please re-enter your password:" p1
        if  [ $p = $p1 ]; then
	    echo "$u,$p" >> login_file.txt	
            echo "Registration complete."
            echo "press 1 for sign in:"
            echo "press 2 for exit:"
	    read press
	    case $press in
                
                1)sign_in
                        ;;
                2)Exit
                        ;;
        esac
        
        else
             echo "Registration unsuccessfull."
	     mscreen_func
        fi
		fi
	fi
        }

take_test(){

      echo "Test started by $u at $login_time." >> login_log.txt
      attempt=/home/ec2-user/lavish/usedcase/user_answers/$u.answer.csv
      if [ -f "$attempt" ]
      then
	      echo "Yov have already taken the test."
      else
	      touch $attempt
	      echo -e "Test screen:\n"
	      for i in `seq 5 5 25`
	      do
      		      answer=""
      		      cat testpaper.txt | head -${i} | tail -5
      		      echo
      		      for j in `seq 10 -1 0`
      		      do
      			      echo -e "\rTime remaining: ${j}s \tChoose your answer: \c"
      			      read -t 1 answer
      			      if [ -n "${answer}" ]
      			      then
      				      break
      			      else
      				      answer=""
      			      fi
      		      done   
		      echo "${answer}" >> /home/ec2-user/lavish/usedcase/user_answers/$u.answer.csv
      	      done
	      
	      echo "Test submitted successfully by $u at $login_file." >> login_log.txt
	      echo -e "Test completed successfully!\n"
      fi
      echo "Choose other options:"
      echo "1. View test"
      echo "2. Sign out"
      echo "3. Exit"
      read press
      case $press in
	      1) view_test
		      ;;
	      2) mscreen_func
		      ;;
	      3) exit
		      ;;
      esac
}	

view_test()
{
	echo "__________VIEW TEST__________"
	u_ans=(`cat /home/ec2-user/lavish/usedcase/user_answers/$u.answer.csv`)
	t_ans=(`cat /home/ec2-user/lavish/usedcase/testanswer.txt`)
	marks=0

	for i in `seq 5 5 25`
	do
		cat testpaper.txt | head -${i} | tail -5
		echo
		echo "The answer giver by you - ${u_ans[$(((${i}/5)-1))]}"
		echo "The correct answer is - ${t_ans[$(((${i}/5)-1))]}"
		echo
		if [ "${u_ans[$(((${i}/5)-1))]}" = "${t_ans[$(((${i}/5)-1))]}" ]
		then
			marks=`expr $marks + 1`
		fi
	done
	echo
	echo "You got $marks out of 5."
	echo "Choose other options."
	echo "1. Logout"
	echo "2. Exit"
	read press
	case $press in
		1) mscreen_func
			;;
		2) exit
			;;
	esac

}

mscreen_func

   
