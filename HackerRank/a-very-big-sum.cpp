#include <bits/stdc++.h>
using namespace std;

int main()
{
    int n, diag, num, leftDiag, rightDiag;

    for(int j = 0; j < n; j++){
        for(int k = 0; k < n; k++){
            cin >> num;
            if(j == k){
                leftDiag += num;
            }
            if(j+k == (n-1)){
                rightDiag += num;
            }
        }
    }
    diag = abs(leftDiag-rightDiag);
    
    cout << diag;
}