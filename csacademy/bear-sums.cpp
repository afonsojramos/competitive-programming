#include <bits/stdc++.h>
using namespace std;

#define INF 100000000

int main(){

    int t; cin >> t;
    while(t--){
        int s, e;
        cin >> s >> e;

        //value, smallest index and frequency
        unordered_map<int, pair<int,int>> table;
        vector<int> items;
        for(int i = 0; i < e; i++){
            int item; cin >> item;
            items.push_back(item);

            unordered_map<int, pair<int,int>>::iterator it = table.find(item);
            if(it == table.end()){
                table.insert({item, {i, 1}});
            }
            else{
                if(table[item].first < i) table[item].first = i;
                table[item].second++;
            }

        }

        map<int, pair<int,int>> pairs;
        for(int i = 0; i < items.size(); i++){
            int complement = s - items.at(i);
            unordered_map<int, pair<int,int> >::iterator it = table.find(complement);
            if(it != table.end()){
                if(items.at(i) == complement)
                    if(it->second.second <= 1)
                        continue;
                
                int index2 = it->second.first;
                pair<int, int> pair_el = make_pair(min(complement, items.at(i)), max(complement, items.at(i)));
                pairs.insert({max(i, index2), pair_el});
                
            }
        }

        if(pairs.size() == 0) 
            cout << "!OK\n";
        else{
            pair<int, int> pair_sol;
            int index = INF;

            for(auto el: pairs){
                if(el.first < index){
                    index = el.first;
                    pair_sol = el.second;
                }
            }

            cout << pair_sol.first << " " << pair_sol.second << endl;  
        }
    }


}