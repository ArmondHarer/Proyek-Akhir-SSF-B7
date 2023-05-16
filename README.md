## **AUTOMATIC CURTAIN SYSTEM**💒

---


## ***INTRODUCTION TO PROJECT***

**BACKGROUND**

Manually opening and closing curtains can be burdensome, especially for hard-to-reach installations. Therefore, an automatic curtain system is needed to effortlessly adjust lighting and privacy levels in the room. The proposed system utilizes light sensors and offers manual control through a potentiometer. By automating curtain control, users can save time and energy while customizing curtain positioning according to their preferences. This automation enhances convenience, comfort, and safety by regulating lighting, temperature, and privacy levels in indoor spaces.

**SOLUTION**

In this project, we will create a simple automation system that can automatically open curtains based on the presence or absence of light in the environment as the solution of the problem mentioned before. We will use Arduino Uno ATMega328p as the microcontroller. The project will have two inputs: a sensor input for automatic curtain opening and a manual input from a potentiometer.
The system will be equipped with a light sensor, photoresistor that measures the ambient light intensity. If the light intensity is too low, the system will activate an SG90 servo motor to open the curtains automatically. Conversely, if the light intensity is too high, the system will close the curtains automatically.
Additionally, the system will have a manual input in the form of a potentiometer that can be used to manually open and close the curtains. With this manual input, users can directly control the curtains when needed.

---


## ***IMPLEMENTATION***

**HARDWARE DESIGN AND IMPLEMENTATION DETAILS**
The hardware design for the automated curtain system includes an Arduino Uno microcontroller as the central control unit, a motor for curtain movement, LEDs for visual indicators, and either a potentiometer or a photoresistor for light sensing. The Arduino Uno receives input signals, processes data, and controls the system. The motor moves the curtains, while the LEDs provide visual feedback. The potentiometer allows manual adjustment of the curtain position, while the photoresistor enables automatic adjustment based on ambient light conditions. The schematic diagram shows two Arduino boards, one as the master and the other as the slave. The slave Arduino is connected to a photoresistor, a potentiometer, and a button for user interaction. The master Arduino controls an LED and a servo motor based on input received from the slave Arduino. Overall, the hardware design integrates these components to create an automated curtain system.

**SOFTWARE IMPLEMENTATION**

The software development for the automatic curtain system includes programming Arduino boards to enable automation. The slave device receives input from a photoresistor and communicates it to the master using I2C. A button on the slave determines the input source. The master interprets the data and controls a servo motor. The process involves board setup, code writing, integration, testing, optimization, and documentation. This ensures a reliable and efficient software solution for automating the curtain system.

---


## ***TESTING AND EVALUATION***

**TESTING**

The testing of the automatic curtain system encompasses validating the functionality and performance of its key components. This includes assessing the photoresistor's accuracy in detecting light levels for appropriate curtain movement, verifying the potentiometer's ability to adjust the curtain position in manual mode, ensuring the LED indicator correctly reflects the selected mode, and testing the servo motor for smooth and precise curtain motion. Overall, the goal is to ensure that all components work together effectively, enabling accurate and reliable curtain control in both sensor-based and manual modes.


**RESULT**

The testing results indicate that the circuit successfully demonstrated servo movement in manual mode through the potentiometer. However, conclusive results for the automatic mode couldn't be obtained due to the need for extensive testing under direct sunlight to evaluate the photoresistor's performance. The interrupt mechanism for switching between modes was implemented successfully, as indicated by the LED light turning on when the button was pressed. These findings suggest that the circuit design and implementation achieved the desired functionality in manual mode, but additional testing and adjustments are required to assess and improve the reliability and effectiveness of the automatic mode.

**EVALUATION**

The evaluation of the Automatic Curtain System identified issues with the interrupt functionality, which is crucial for timely response to external events like mode switching. The evaluation will focus on identifying the cause of the interrupt failure to rectify it. Additionally, the evaluation revealed inconsistencies in the servo motor's movement, affecting both manual and automatic modes. Investigating and addressing these issues will allow for improvements to be made, ensuring reliable and efficient operation of the system. By addressing these concerns, the Automatic Curtain System can deliver a seamless user experience.

---

## ***CONCLUSION***
The Automatic Curtain System is designed to provide convenience and comfort by automating the control of curtains. It utilizes a light sensor and a servo motor to enable automatic opening and closing of curtains without manual intervention. This system is constructed using readily available components and can be easily expanded to include additional features like remote control or scheduled operations. Overall, the Automatic Curtain System offers an efficient and customizable solution that enhances user comfort and eliminates the need for manual adjustments.

