#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <map>
#include <algorithm>
#include <set>

using namespace std;

typedef unsigned int uint;

/**
 * HashCode 2017 - Caches
 */

string home = "/Users/andre/Documents/Paprika/";
string fileName = "videos_worth_spreading";
string fileDest = home + fileName + ".in";
string fileOut = home + fileName + "7.out";


class Endpoint {
private:
    static uint count;
    
public:
    uint id;
    uint dc_lat;
    map<uint,uint> cache_lat;
    map<uint,uint> requests;
    //vector<uint> ordered_caches; // ordered by increasing latency
    
    Endpoint() : id(count++) {};
    
    
    Endpoint & operator=(const Endpoint & edp) = default;
    
    int mostRequestedVideo() const {
        auto it = max_element(requests.begin(), requests.end(), [&](pair<uint,uint> p1, pair<uint,uint> p2) {
            return p1.second < p2.second;
        });
        
        if (it == requests.end())
            return -1;
        
        return it->first;
    }
    
    int mostRequests() {
        return requests[mostRequestedVideo()];
    }
    
    int leastLatCache() const {
        auto it = min_element(cache_lat.begin(), cache_lat.end(), [&](pair<uint,uint> p1, pair<uint,uint> p2) {
            return p1.second < p2.second;
        });
        
        if (it == requests.end())
            return -1;
        
        return it->first;
    }
    
    int leastLatency() {
        return cache_lat[leastLatCache()];
    }
    
//    bool sortCaches() {
//        if (cache_lat.empty())
//            return false;
//        
//        ordered_caches.reserve(cache_lat.size());
//        for (auto p : cache_lat)
//            ordered_caches.push_back(p.first);
//        
//        stable_sort(ordered_caches.begin(), ordered_caches.end(), [&](uint c1, uint c2) {return cache_lat[c1] < cache_lat[c2]; });
//        
//        return true;
//    }
};
uint Endpoint::count = 0;

class Video {
    static uint count;
    
public:
    const uint id;
    const uint size;
    
    Video(uint size) : size(size), id(count++) {}
};
uint Video::count = 0;

class Cache {
    static uint count;
    
public:
    const uint id;
    uint free_mem;
    set<uint> videos;
    
    Cache(uint memory) : free_mem(memory), id(count++) {}
    
    bool insertVideo(const Video & v) {
        if (free_mem < v.size)
            return false;
        
        auto res_pair = videos.insert(v.id);
        
        if (res_pair.second == false)
            return false;
        
        free_mem -= v.size;
        
        return true;
    }
    
    bool isValid(const Video & v) const {
        if (free_mem < v.size)
            return false;
        
        if (videos.find(v.id) != videos.end())
            return false;
        
        return true;
    }
    
    friend ostream & operator<<(ostream& out, const Cache & c) {
        out << c.id << " ";
        for (uint id : c.videos) {
            out << id << " ";
        }
        out << endl;
        
        return out;
    }
};
uint Cache::count = 0;

class Solution {
    uint num_videos;
    uint num_endpoints;
    uint num_requests;
    uint num_caches;
    uint cache_mem;
    
    vector<Video> videos;
    vector<Endpoint> endpoints;
    
    vector<Cache> caches;
    
    set<uint> used_caches;
    
    class Container {
    public:
        uint edp_id;
        uint vd_id;
        uint cache_id;
        uint savings = 0;
        
        Container() = default;
        
        Container(Endpoint & edp) : edp_id(edp.id), vd_id(edp.mostRequestedVideo()), cache_id(edp.leastLatCache()) {
            savings = (edp.dc_lat - edp.leastLatency()) * edp.mostRequests();
        }
    };
    
public:
    Solution(ifstream & ifs) {
        ifs >> num_videos >> num_endpoints >> num_requests >> num_caches >> cache_mem;
        
        for (uint i = 0; i < num_videos; i++) {
            uint vid_size;
            ifs >> vid_size;
            videos.emplace_back(vid_size);
        }
        
        for (uint i = 0; i < num_endpoints; i++) {
            Endpoint edp;
            
            ifs >> edp.dc_lat;
            
            uint num;
            ifs >> num;
            for (uint j = 0; j < num; j++) {
                uint id, c_lat;
                ifs >> id >> c_lat;
                edp.cache_lat[id] = c_lat;
            }
            
//            edp.sortCaches();
            endpoints.push_back(edp);
        }
        
        for (uint i = 0; i < num_requests; i++) {
            uint reqs, video_id, edp_id;
            
            ifs >> video_id >> edp_id >> reqs;
            
            endpoints[edp_id].requests[video_id] = reqs;
        }
        
        
        // Populate Caches
        for (uint i = 0; i < num_caches; i++) {
            caches.emplace_back(cache_mem);
        }
        
        // Don't
        //        videos.erase(remove_if(videos.begin(), videos.end(), [=](const Video & v) {
        //            return v.size < cache_mem;
        //        }), videos.end());
    }
    
    int findEdpIdx(uint ide) {
        for (uint i = 0; i < endpoints.size(); i++) {
            if (endpoints[i].id == ide)
                return i;
        }
        
        return -1;
    }
    
    void solve() {
        
        // sort in decreasing order datacenter latency
//        stable_sort(endpoints.begin(), endpoints.end(), [&](Endpoint edp1, Endpoint edp2){
//            return ((edp1.dc_lat - edp1.cache_lat[edp1.leastLat()]) * edp1.requests[edp1.mostRequested()]) > ((edp2.dc_lat - edp2.cache_lat[edp2.leastLat()]) * edp2.requests[edp2.mostRequested()]);
//        });
        
        stable_sort(endpoints.begin(), endpoints.end(), [&](Endpoint edp1, Endpoint edp2){
            return edp1.dc_lat > edp2.dc_lat;
        });
        
        uint vids_added = 0;
        
        // Optimize savings per megabyte used  in cache ?
        
        bool somethingDone;
        
        do {
            somethingDone = false;
            
            Container max;
            
            for (Endpoint & edp : endpoints) {
//                int video_id, cache_id;
//                if ( (video_id = edp.mostRequestedVideo()) == -1 ) {
//                    continue;
//                }
//                
//                if ( (cache_id = edp.leastLatCache()) == -1 ) {
//                    continue;
//                }
//                
//                if (caches[cache_id].insertVideo(videos[video_id])) {
//                    edp.requests[video_id] = 0;
//                    used_caches.insert(cache_id);
//                    somethingDone = true;
//                }
                
                Container c(edp);
                
                if (c.savings > max.savings && caches[c.cache_id].isValid(videos[c.vd_id])) {
                    max = c;
                    somethingDone = true;
                }
            }
            
            if (max.savings == 0)
                break;
            
            if (caches[max.cache_id].insertVideo(videos[max.vd_id])) {
                endpoints[findEdpIdx(max.edp_id)].requests[max.vd_id] = 0;
                used_caches.insert(max.cache_id);
                
                if (++vids_added % 50 == 0)
                    cout << "Videos Added: " << vids_added << endl;
                
            }
            else {
                cout << "\nnot cool vid?\n";
            }
            
        } while(somethingDone);
        
        cout << "\nUsing unused caches.\n";
        // Use unused caches
        for (Cache & c : caches) {
            if (used_caches.find(c.id) != used_caches.end()) // Cache in use ?
                continue;
            
            
            for (Endpoint & edp : endpoints) {
                if (edp.cache_lat.find(c.id) == edp.cache_lat.end()) // Not Connected to cache ?
                    continue;
                
                do {
                    somethingDone = false;
                    
                    uint vid_idx = edp.mostRequestedVideo();
                    if (caches[c.id].insertVideo(videos[vid_idx])) {
                        edp.requests[vid_idx] = 0;
                        used_caches.insert(c.id);
                        
                        somethingDone = true;
                        
                        if (++vids_added % 20 == 0)
                            cout << "Videos Added: " << vids_added << endl;
                    }
                    
                } while(somethingDone);

            }
        }
    }
    
    
    void print(ostream & out) {
        out << used_caches.size() << endl;
        for (uint idx : used_caches) {
            out << caches[idx];
        }
    }
    
};

int main() {
    cout << "HASHCODE 2017\n";
    
    ifstream ifs (fileDest);
    ofstream ofs (fileOut);
    
    if (! ifs.is_open()) {
        cout << "BAD FILE!!!\n";
        return 1;
    }
    
    Solution sol(ifs);
    
    sol.solve();
    
    sol.print(ofs);
    
    return 0;
}







