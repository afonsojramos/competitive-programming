#include <bits/stdc++.h>

using namespace std;

list<string>::iterator shortestOf(list<string> & strings) {
    auto where = strings.end();
    size_t minLen = size_t(-1);
    for (auto i = strings.begin(); i != strings.end(); ++i) {
        if (i->size() < minLen) {
            where = i;
            minLen = i->size();
        }
    }
    return where;
}

bool isCommonSubstringOf( string const & candidate, list<string> const & strings) {
    for (string const & s : strings) {
        if (s.find(candidate) == string::npos) {
            return false;
        }
    }
    return true;
}

multimap<size_t,string> longestCommonSubstringSets(list<string> & strings, unsigned quota) {
    size_t nlen = 0;
    multimap<size_t,string> results;
    if (quota == 0) {
        return results;
    }
    auto shortest_i = shortestOf(strings);
    if (shortest_i == strings.end()) {
        return results;
    }
    string shortest = *shortest_i;
    strings.erase(shortest_i);
    for ( size_t start = 0; start < shortest.size();) {
        size_t skip = 1;
        for (size_t len = shortest.size(); len > 0; --len) {
            string subs = shortest.substr(start,len);
            if (!isCommonSubstringOf(subs,strings)) {
                continue;
            }
            auto i = results.lower_bound(subs.size());
            for (   ;i != results.end() && 
                    i->second.find(subs) == string::npos; ++i) {}
            if (i != results.end()) {
                continue;
            }
            for (i = results.begin(); 
                    i != results.end() && i->first < subs.size(); ) {
                if (subs.find(i->second) != string::npos) {
                    i = results.erase(i);
                } else {
                    ++i;
                }
            }
            auto hint = results.lower_bound(subs.size());
            bool new_len = hint == results.end() || hint->first != subs.size();
            if (new_len && nlen == quota) {
                size_t minLen = results.begin()->first;
                if (minLen > subs.size()) {
                    continue;
                }
                results.erase(minLen);
                --nlen;
            }
            nlen += new_len;
            results.emplace_hint(hint,subs.size(),subs);
            len = 1;
            skip = subs.size();
        }
        start += skip;
    }
    return results; 
}

int main() {
    int n, l, max = 0;
    cin >> n >> l;

    list<string> strings;
    string s;
    
    for(int i = 0; i < n; i++) {
        cin >> s;
        strings.push_back(s);
    }

    auto results = longestCommonSubstringSets(strings,4);
    for (auto const & val : results) {
        if (max < val.first){
            max = val.first;
            s = val.second;
        }
    }
    
    cout << s << endl;
    
    return 0;
}