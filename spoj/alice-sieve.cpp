#include<bits/stdc++.h>

using namespace std;

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(NULL);
    int t;
    cin >> t;

    while (t--) {
        int size, res;
        cin >> size;
        
        size%2 == 0 ? res = size/2 : res = size/2 + 1;

        cout << res << '\n';
    }
    return 0;
}