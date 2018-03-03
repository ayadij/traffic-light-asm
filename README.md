# traffic-light-asm
2016 BYU CS 224 Lab 4


### Description:
"Program a pedestrian traffic light for a street with a crosswalk. Use the large red, yellow, and green LEDs for the car traffic and the smaller red and green LEDs along with the orange LED for pedestrians. Four traffic light states (Green, Yellow, Red, and Pedestrian) are used to allow pedestrians to safely cross a busy street as well as calm the traffic.

### Explore:
- Construct more complex timing loops in assembly.
- Use callee-save subroutines to reduce code size and maximize program modularity.
- Access and control Input/Output devices using memory mapped I/O.



### Specs:
- 1 point	Your traffic stoplight program source code contains header comments that include your name and a declaration that the completed assignment is your own work.
- 1 point	The assembler directive .equ is used to define all delay counts and constants.
- 2 points	All software timing delays are implemented using an assembly subroutine that delays in 1/10 second increments. All subroutines are implemented using a callee-save protocol.
- 4 points	Your traffic stoplight machine works as follows:
  - The normal traffic light cycle is 30 seconds and consists of three states:
    - Green State 1: Green light is on for 20 seconds.
    - Yellow State 2: Yellow light is on for 5 seconds.
    - Red State 3: Red light is on for 5 seconds.
  - During the normal cycle, pedestrians are not allowed to cross the street (indicated by the small red LED being on and the small green LED being off).
  - When any switch is pressed, the orange LED immediately turns on and the normal cycle is altered as follows:
    - Green State 1: Green light is on for 20 seconds.
    - Yellow State 2: Yellow light is on for 5 seconds.
    - Pedestrian State 4: Red light is turned on and orange LED is turned off. The small red LED is turned off and the small green LED is turned on. After 5 seconds, the small green LED toggles on and off every second for 6 seconds, followed by a rapid toggling every fifth of a second for 4 seconds.
  - After State 4, the traffic light returns to the normal Red-Yellow-Green cycle.
- 1 point	Pressing any push button at any time turns on the orange LED. (Maximum of 1/10 second delay from switch press to orange LED turning on.) The pedestrian sequence only occurs at the end of the yellow state and the orange LED is on.
- 1 point	The total traffic light cycle time (without a push button having been pressed) is 30 seconds with less than a 1/2 second error.

https://students.cs.byu.edu/~clement/cs224/labs/L05b-traffic/traffic.php?BeforeYouBegin=1&ProgrammingSuggestions=1


