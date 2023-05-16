## **INTRODUCTION TO PROJECT**

***BACKGROUND***
Manually opening and closing curtains can be burdensome, especially for hard-to-reach installations. Therefore, an automatic curtain system is needed to effortlessly adjust lighting and privacy levels in the room. The proposed system utilizes light sensors and offers manual control through a potentiometer. By automating curtain control, users can save time and energy while customizing curtain positioning according to their preferences. This automation enhances convenience, comfort, and safety by regulating lighting, temperature, and privacy levels in indoor spaces.

***SOLUTION***
In this project, we will create a simple automation system that can automatically open curtains based on the presence or absence of light in the environment as the solution of the problem mentioned before. We will use Arduino Uno ATMega328p as the microcontroller. The project will have two inputs: a sensor input for automatic curtain opening and a manual input from a potentiometer.
The system will be equipped with a light sensor, photoresistor that measures the ambient light intensity. If the light intensity is too low, the system will activate an SG90 servo motor to open the curtains automatically. Conversely, if the light intensity is too high, the system will close the curtains automatically.
Additionally, the system will have a manual input in the form of a potentiometer that can be used to manually open and close the curtains. With this manual input, users can directly control the curtains when needed.

## **HARDWARE DESIGN AND IMPLEMENTATION DETAILS**
The hardware design for the automated curtain system includes an Arduino Uno microcontroller as the central control unit, a motor for curtain movement, LEDs for visual indicators, and either a potentiometer or a photoresistor for light sensing. The Arduino Uno receives input signals, processes data, and controls the system. The motor moves the curtains, while the LEDs provide visual feedback. The potentiometer allows manual adjustment of the curtain position, while the photoresistor enables automatic adjustment based on ambient light conditions. The schematic diagram shows two Arduino boards, one as the master and the other as the slave. The slave Arduino is connected to a photoresistor, a potentiometer, and a button for user interaction. The master Arduino controls an LED and a servo motor based on input received from the slave Arduino. Overall, the hardware design integrates these components to create an automated curtain system.

## **SOFTWARE IMPLEMENTATION**

The software development for the automatic curtain system includes programming Arduino boards to enable automation. The slave device receives input from a photoresistor and communicates it to the master using I2C. A button on the slave determines the input source. The master interprets the data and controls a servo motor. The process involves board setup, code writing, integration, testing, optimization, and documentation. This ensures a reliable and efficient software solution for automating the curtain system.



