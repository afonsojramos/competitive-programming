#include <bits/stdc++.h>

using namespace std;

int bitcount(int x) {
    int sum = 0;
    while (x != 0)
    {
        sum += x % 2;
        x /= 2;
    }
    return sum;
}
int main() {
    int x;
    cin >> x;
    cout << bitcount(x) << "\n";
    return 0;
}