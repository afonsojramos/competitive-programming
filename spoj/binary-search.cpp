#include<iostream>
#include<stdio.h>
#include<vector>
#include<algorithm>

using namespace std;

int v[2500*2500],v1[2500*2500];

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(NULL);
    int size;
    cin >> size;
    int a[2500], b[2500], c[2500], d[2500];
    
    for(int i = 0 ; i < size ; i++)
        cin >> a[i] >> b[i] >> c[i] >> d[i];

    int cnt = 0;
    // fill v and v1 with a, b and c, d respectively
    for(int i = 0 ; i < size ; i++) {
        for(int j=0 ; j < size ; j++) {
            v[cnt] = a[i] + b[j];
            v1[cnt++] = c[i] + d[j];
        }
    }
    
    sort(v, v+cnt);
    sort(v1, v1+cnt);
    
    long long int ans = 0;
    
    int i = 0, j = cnt - 1;
    int freq1 = 1, freq2 = 1;
    
    // binary search
    while(i < cnt && j >= 0) { 
        long long sum = v[i] + v1[j];

        while(i + 1 < cnt && v[i] == v[i+1]) {
            freq1++;
            i++;
        }
        while(j-1 >= 0 && v1[j] == v1[j-1]){
            freq2++;
            j-- ;
        } 
 
        if(sum == 0){
            ans += (long long)freq1*(long long)freq2;
            i++;
            j--;
            freq1 = 1;
            freq2 = 1;
        } else if(sum > 0) {
            j--;
            freq2 = 1;        
        } else {
            i++;
            freq1 = 1;
        }
    }

    cout << ans;

    return 0;
}