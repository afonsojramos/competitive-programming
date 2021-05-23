#include <bits/stdc++.h>
using namespace std;

int main(){

    string input, s1 = "", s2 = "", solution = "";
    cin >> input;

    if(input.size() % 2 != 0){
        cout << "impossible\n";
        return 0;
    }

    int s_size = input.size() / 2;
    int opens = s_size / 2;

    stack<char> open_stack_n, open_stack_c;
    for(int i = 0; i < input.size(); i++){
        
        if(input[i] == '(' || input[i] == '['){
            if(opens > 0){
                solution += "1";
                opens--;

                if(input[i] == '('){
                    open_stack_n.push(input[i]);
                    s1 += "(";
                    continue;
                }

                if(input[i] == '['){
                    open_stack_c.push(input[i]);
                    s1 += "[";
                    continue;
                }
            }
            else{
                solution += "2";
                s2 += input[i];
                continue;
            }
        }

        if(input[i] == ')' || input[i] == ']'){

            if(input[i] == ')'){
                if(!open_stack_n.empty()){
                    solution += "1";
                    s1 += ')';
                    open_stack_n.pop();
                    continue;
                }
                else{
                    solution += "2";
                    s2 += input[i];
                    continue;
                }
            }

            if(input[i] == ']'){
                if(!open_stack_c.empty()){
                    solution += "1";
                    s1 += ']';
                    open_stack_c.pop();
                    continue;
                }
                else{
                    solution += "2";
                    s2 += input[i];
                    continue;
                }
            }
            
        }
    }

   
    if(s1.size() != s2.size()){
        cout << "impossible\n";
        return 0;
    }

    if(s1.size() + s2.size() != input.size()){
        cout << "impossible\n";
        return 0;
    }

    for(int i = 0; i < solution.size()-1; i++)
        cout << solution[i] << " ";

    cout << solution[solution.size()-1] << endl;
}