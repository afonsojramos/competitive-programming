#include <bits/stdc++.h>
using namespace std;

int main(){
    int a0, a1, a2, b0, b1, b2;
    cin >> a0 >> a1 >> a2 >> b0 >> b1 >> b2;
    
    int a = ((a0 > b0)?1:0) + ((a1>b1)?1:0) + ((a2>b2)?1:0);
    int b = ((a0 < b0)?1:0) + ((a1<b1)?1:0) + ((a2<b2)?1:0);
    
    cout << a << " " << b << endl;  
    return 0;
}