import java.util.*;

List<Die> allDice = new ArrayList<Die>();

void setup() {
	// Window size
	size(350, 450);
	// Style initializations
	noStroke();
	rectMode(CENTER);
	textAlign(CENTER, CENTER);

	// Debug
	noLoop();
}

void draw() {
	background(200);
	for(Die dice : allDice) {
		dice.update();
		dice.show();
	}
}

void mouseClicked() { // Starts the draw loop when mouse is pressed
	loop(); // Starts the loop
	for(Die dice : allDice) { // Cause all not falling dice to fall
		if(!dice.falling) {
			dice.setToFall();
		}
	}
	for(int x = 25; x <= width - 25; x += 30) {
		for(int y = 25; y <= height - 25 - 100; y += 30) {
			allDice.add(new Die(x, y));
		}
	}
}

class Die { // A single die

	// Die properties
	float x, y; // Position of the die
	double velX, velY; // Velocity of the die
	float deg = 0; // The rotation of the die in degrees
	float s = 1; // The size of the die
	float growthRate = 1; // The growth rate of the die
	float maxS = 25; // The maximum size of the die
	int num; // The number on the die

	// Die states
	boolean growing = true;
	boolean falling = false;
	
	Die(int argX, int argY) {
		x = argX;
		y = argY;
		num = (int)(Math.random() * 6 + 1); // Rolls the die a random number
		deg = -maxS / growthRate + s; // Calculate starting rotational angle based on growing speed so that the die is right side up when done
	}
	void update() { // Updates the position and size of the die based on its current state
		if(growing) {
			if(s < maxS) {
				s += growthRate;
				deg += 1;
			}
			else{
				s = maxS;
				deg = 0;
				growing = false;
			}
		}
		if(falling) {
			x += velX;
			y += velY;
			velX *= 0.95;
			velY += 1;
		}
	}
	void setToFall() { // Set the dice to fall
		falling = true;
		// Set the velocity of the die when falling
		velX = Math.random() * 20 - 10;
		velY = Math.random() * -10;
	}
	void show() { // Displays the die
		translate(x, y); // Translates the die to position
		rotate(radians(deg)); // Rotates the die
		rect(0, 0, s, s, 5);
		rotate(radians(-deg)); // Unrotates the die
		translate(-x, -y); // Untranslates die position
	}
}
