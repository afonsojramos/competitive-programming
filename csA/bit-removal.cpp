#include<bits/stdc++.h>
#define fastcin ios_base::sync_with_stdio(0), cin.tie(NULL)

using namespace std;

int main(){
	fastcin;
	int x, y, t;
	cin >> t;

	while ( t-- ) { 
	    cin >> x >> y;
	    cout << (x^(x&y)) << '\n';
	}

	return 0;
}