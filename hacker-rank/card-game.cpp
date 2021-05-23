#include <bits/stdc++.h>
#include <map>

using namespace std;

int main(){
    int n;
    cin >> n;
    
    int num[n], max = 0, maxn = 0;
    bool fail = false;
    std::map<int, int> dups; 
    
    for(int i = 0; i < n; i++){
        cin >> num[i];
        dups[num[i]]++;  
        
        if (max < num[i]){              
            max = num[i];
            maxn = 1;
        }
        else if (max == num[i]){
            maxn ++;
        }
    }
    
    for (auto &e:dups){
        if(e.second % 2 != 0)
            fail=true;
    }    
    
    if (maxn%2!=0)
        cout << "Sinf";
    else if (maxn%2==0 && fail)
        cout << "Sinf";
    else   
        cout << "Ni";
    return 0;
}