#include <iostream>
 
using namespace std;
 
int main(){
	int x;
    bool y = true;
 
	while (y) { 
	    cin >> x;
        if (x == 42) y = false;
        else cout << x << '\n';
	}
    return 0;
}