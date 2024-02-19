# Herbie Questions

## Regimes
using command for testing
racket infra/ci.rkt --precision binary64 --seed 0 bench/hamming/

- Input
    Called I number of times per problem
    Contains CA number of candidates/ alternatives
    Has P number of points
- Output
    List of Split index
        #(#s(si 17 256) #s(si 15 91))
        - use candidate 15 for left side 
        - use candidate 17 for right half 
        - split at point 91
    [ ] what is the end goal here?
    [ ] 4 vectors of what?
    [ ] Why always the last set of split index?
        - has the highest cost
        - is the rest of the array the "work"/steps to get the result?
### Data Types
#### Split-Index
- Candidate Index
- Point Index
#### CSE
- cost 
    - accumulated cost
    - [?] Is this our BS cost value?
- indices
    - a list of SI

### Algorithm
#### Maybe want
for each point
    check cost of all candidates
    set output for that point to that candidate?
    update current cost?

#### Maybe Current 
working from left to right
figure out the best alt for that point and return it
repeat for each point

Take in a list of 
    - errors representing the alternatives we can use
    - booleans that determine when we can split
        - [?] when and how is this determined?
#### Code
num-candidates
    - varies based on problem and interation?
    - [?] How many iterations are run?
err-lsts-vec
    - why is error close to 60 usually? at least for hamming 
num-points
    - almost always 256, Why?
acost
    - accumulated cost?
    - rest for each point



