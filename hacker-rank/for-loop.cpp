#include <bits/stdc++.h>
using namespace std;

int main(){
    int n, max;
    cin >> n >> max;    
    
    for(; n <= max; n++){
        if (n>9)
            n%2 == 0 ? cout << "even" << endl : cout << "odd" << endl;
        else if (n==1)
            cout << "one" << endl;
        else if (n==2)
            cout << "two" << endl;
        else if (n==3)
            cout << "three" << endl;
        else if (n==4)
            cout << "four" << endl;
        else if (n==5)
            cout << "five" << endl;
        else if (n==6)
            cout << "six" << endl;
        else if (n==7)
            cout << "seven" << endl;
        else if (n==8)
            cout << "eight" << endl;
        else if (n==9)
            cout << "nine" << endl;
    }
    
    return 0;
}