#include <bits/stdc++.h>
using namespace std;

int main()
{
    int n;
    long total = 0;
    cin >> n;
    int a[n][n];
        
    for (int i = 0; i < n; i++) {
        for(int j = 0 ; j < n ; j++) {
            cin >> a[i][j];
        }
        total += a[i][i];
        total -= a[i][(n-1)-i];
    }
    cout << abs(total) << endl;
}