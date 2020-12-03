#include <bits/stdc++.h>
using namespace std;
int main(){
    int n, m, s;
    cin >> n >> m >> s;
    cout << ceil(log2(n)) * s + (n-1) * m << endl;
}