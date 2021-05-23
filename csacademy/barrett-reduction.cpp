#include <bits/stdc++.h>
 
using namespace std;

int main(){
    unsigned long long int a, b; 
    
    cin >> a >> b;
    
    unsigned long long int min = pow(2,b)/a;
    unsigned long long int constant = pow(2,b)/a;
    
    for (unsigned long long int i = min ; i > a ; i--) {
        if (i == constant){
            min = i;
        }
    }

    cout << min << endl;
}