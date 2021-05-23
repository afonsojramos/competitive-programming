#include <iostream>
#include <math.h>
#define fastcin ios_base::sync_with_stdio(0), cin.tie(NULL)

using namespace std;

int main() {
    int a, b;
    fastcin;
    cin >> a >> b;
    
    cout << (int)sqrt(b) - (int)sqrt(a-1) << "\n";
    return 0;
}