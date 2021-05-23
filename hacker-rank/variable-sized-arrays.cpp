#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
using namespace std;


int main() {
    int n, q;
    cin >> n >> q;
    vector<int> a[n];
    
    for(int i = 0; i < n; i++){
        int size, num; 
        cin >> size;        

        while(size > 0){
            cin >> num;
            a[i].push_back(num);
            size--;        
        }
    }

    for(int i = 0; i < q; i++){
        int j, k;
        cin >> j >> k;
        cout << a[j].at(k) << endl;
    }
}