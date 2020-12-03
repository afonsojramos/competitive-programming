//
//  main.cpp
//  hashcode2018
//

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

using namespace std;

typedef unsigned int uint;
typedef pair<uint, uint> uintp;

uint pairsDistance(uintp p1, uintp p2);

class Ride {
public:
    static uint ridesCount;
    uint id;
    
    uintp startPos;
    uintp endPos;
    uint earliestStart;
    uint latestFinish;
    
    Ride(uintp startPos, uintp endPos, uint earliestStart, uint latestFinish) :
        startPos(startPos), endPos(endPos), earliestStart(earliestStart), latestFinish(latestFinish) {
            this->id = Ride::ridesCount++;
        }
    
    uint getDistance() const {
        return pairsDistance(startPos, endPos);
    }
};
uint Ride::ridesCount = 0;


class Vehicle {
public:
    static uint vehicleCount;
    uint id;
    
    uint turnsBusy = 0;
    pair<uint, uint> currentPos = make_pair(0, 0);
    pair<uint, uint> destPos = make_pair(0, 0);
    
    vector<uint> rides;
    
    Vehicle() {
        this->id = Vehicle::vehicleCount++;
    }
    
    bool addRide(Ride r, uint currentSteps) {
        if (turnsBusy > 0)
            return false;
        
        uint stepsToRide = pairsDistance(currentPos, r.startPos);
        if (r.getDistance() + stepsToRide > r.latestFinish)
            return false;
        
        rides.push_back(r.id);
        turnsBusy = r.getDistance();
        destPos = r.endPos;
        
        turnsBusy += stepsToRide;
        
        if (stepsToRide + currentSteps < r.earliestStart) {
            turnsBusy += r.earliestStart - (stepsToRide + currentSteps);
        }
        
        return true;
    }
    
    int getBestRide(const vector<Ride> & rides, int currentSteps, int bonus) const {
        int bestIdx = -1;
        float bestScorePerSteps = 0;
        
        for (int idx = 0; idx < rides.size(); idx++) {
            int distance = pairsDistance(this->currentPos, rides[idx].startPos);
            int arrival = currentSteps + distance;
            if (arrival + rides[idx].getDistance() > rides[idx].latestFinish)
                continue;
            if (arrival < rides[idx].earliestStart)
                distance += rides[idx].earliestStart - arrival;
            
            if(distance > rides[idx].latestFinish)
                continue;
            
            float thisScorePerSteps = ((float) rides[idx].getDistance() + bonus) / distance;
            
            if (bestIdx == -1 or bestScorePerSteps < thisScorePerSteps) {
                bestScorePerSteps = thisScorePerSteps;
                bestIdx = idx;
            }
        }
        
        return bestIdx;
    }
    
    bool isBusy() const {
        return turnsBusy > 0;
    }
    
    void nextStep() {
        if (turnsBusy > 0)
            turnsBusy--;
        if (turnsBusy == 0)
            currentPos = destPos;
    }
};
uint Vehicle::vehicleCount = 1;


class Solver {
public:
    vector<Vehicle> vehicles;
    vector<Ride> rides;
    uint stepsRemaining;
    uint stepsTaken = 0;
    
    uint bonus;
    
    uint rows, cols;
    
    Solver(ifstream & ifs) {
        string s;
        stringstream ss;
        getline(ifs, s);
        ss << s;
        
        cout << "Dataset Settings: " << s << endl;
        
        uint nVeic, nRides;
        ss >> this->rows >> this->cols >> nVeic >> nRides >> this->bonus >> this->stepsRemaining;
        
        vehicles = vector<Vehicle>(nVeic);

        while (getline(ifs, s)) {
            ss.clear();
            ss << s;
            
            uint r0, c0, r1, c1, start, end;
            ss >> r0 >> c0 >> r1 >> c1 >> start >> end;
            rides.push_back(Ride(make_pair(r0, c0), make_pair(r1, c1), start, end));
        }
        
        if (rides.size() != nRides) {
            cout << "ERROR IN RIDES EXTRACTION!\n";
        }
    }
    
    void nextStep() {
        this->stepsRemaining--;
        this->stepsTaken++;
        
        for (auto it = vehicles.begin(); it != vehicles.end(); it++) {
            it->turnsBusy--;
        }
    }
    
    void solveRideOriented() {
        // Sort rides per earliest start
        sort(rides.begin(), rides.end(), [&](Ride r1, Ride r2) {
            return r1.getDistance() < r2.getDistance();
        });
        
        while (this->stepsRemaining > 0 and rides.size() > 0) {
            Ride ride = rides.back();
            auto p = getLeastDeadTimePair(ride); // CHANGE 0
            
            if (p.second == -1)
                this->nextStep();
            
            int vehicleIdx = p.first;
            vehicles[vehicleIdx].addRide(ride, this->stepsTaken);
            
            rides.pop_back();
        }
        
        cout << "yay" << endl;
    }
    
    /**
     * Returns <vehicleIdx, vehicle_pos -> ride_start distance>.
     * Pair returned corresponds to the least lost time pair.
     * Lost time is the time the vhicle spends getting to the start location +
     *  the time waiting for the ride's earliest_start.
     */
    pair<uint, int> getLeastDeadTimePair(Ride & r) {
        uint closestVehicleIdx;
        int closestDist = -1;
        
        for (int idx = 0; idx < vehicles.size(); idx++) {
            Vehicle v = vehicles[idx];
            uint dist = pairsDistance(v.currentPos, r.startPos);
            if ((closestDist < 0 or dist < closestDist) and (not v.isBusy())) {
                closestDist = dist;
                closestVehicleIdx = idx;
            }
        }
        
        return make_pair(closestVehicleIdx, closestDist);
    }
    
    void solveVehicleOriented() {
        int previousSteps = 0;
        
        while (this->stepsRemaining > 0 and rides.size() > 0) {
            bool busy = true;
            
            for (int idx = 0; idx < vehicles.size(); idx++) {
                if (vehicles[idx].isBusy())
                    continue;
                else
                    busy = false;
                
                int bestRideIdx = vehicles[idx].getBestRide(rides, this->stepsTaken, this->bonus);
                if (bestRideIdx == -1)
                    continue;
                vehicles[idx].addRide(rides[bestRideIdx], this->stepsTaken);
                rides.erase(rides.begin() + bestRideIdx);
            }
            
            if (busy || previousSteps == this->stepsRemaining) {
                this->nextStep();
            }
            previousSteps = this->stepsRemaining;
        }
    }
    
    void writeToFile(ofstream & out) {
        // Sort vehicles per ID (original positions)
        sort(vehicles.begin(), vehicles.end(), [](Vehicle v1, Vehicle v2) {
            return v1.id < v2.id;
        });
        
        for (const Vehicle& v : vehicles) {
            out << v.rides.size();
            for (uint n : v.rides)
                out << " " << n;
            out << endl;
        }
    }
};

uint pairsDistance(uintp p1, uintp p2) {
    return abs((int) p1.first - (int) p2.first) + abs((int) p1.second - (int) p2.second);
}

int main(int argc, const char * argv[]) {
    string filenames[] = {"a_example", "b_should_be_easy", "c_no_hurry", "d_metropolis", "e_high_bonus"};
    
    vector<ifstream> inputs;
    for (string s : filenames) {
        inputs.emplace_back("Input/" + s + ".in");
        if (not inputs.back().is_open()) {
            cout << "FAILED FILE OPEN\n";
            return 1;
        }
    }
    
    vector<Solver> solvers;
    for (int idx = 0; idx < inputs.size(); idx++) {
        Ride::ridesCount = 0;
        Vehicle::vehicleCount = 1;

        Solver solver = Solver(inputs[idx]);
        inputs[idx].close();
        
        solver.solveVehicleOriented();
        
        ofstream output (filenames[idx] + ".out");
        solver.writeToFile(output);
        output.close();
    }

    return 0;
}
