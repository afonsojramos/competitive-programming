#include<bits/stdc++.h>

using namespace std;

#define INF 1000000

bool is_minor( int a, int b, int c ) {
	return a + b < c;
}

int main() {
	int n, m;
    cin >> n >> m;
	int K[n][m], dp[n][m];
	int i, j;

	for ( i = 0 ; i < n ; ++i ) {
		for ( j = 0 ; j < n ; ++j ) {
            cin >> K[i][j];
			dp[i][j] = INF;
		}
	}

    // Starting Point
	for ( i = 0 ; i < m ; ++i ) {
		dp[0][i] = K[0][i];
	}


	for ( i = 0 ; i < n - 1 ; ++i ) {
		for ( j = 0 ; j < m ; ++j ) {
            // If in next city Bus above is cheaper
			if (j - 1 >= 0 && is_minor(dp[i][j], K[i + 1][j - 1], dp[i + 1][j - 1])) { 
				dp[i + 1][j - 1] = dp[i][j] + K[i + 1][j - 1];
			}
            // If in next city Bus in front is cheaper
			if ( is_minor(dp[i][j], K[i + 1][j], dp[i + 1][j])) {
				dp[i + 1][j] = dp[i][j] + K[i + 1][j];
			}
            // If in next city Bus below is cheaper
			if (j + 1 < m && is_minor(dp[i][j], K[i + 1][j + 1], dp[i + 1][j + 1])) {
				dp[i + 1][j + 1] = dp[i][j] + K[i + 1][j + 1];
			}
		}
	}

	int min = INF;
	
    for ( i = 0 ; i < m ; ++i ) {
		if ( dp[n - 1][i] < min ) {
			min = dp[n - 1][i];
		}
	}
	
    cout << min;

	return 0;
}