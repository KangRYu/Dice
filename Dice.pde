import java.util.*;

List<Die> activeDice = new ArrayList<Die>(); // A list holding all the active dice, the ones in a grid
List<Die> fallingDice = new ArrayList<Die>(); // A list holding all the falling dice
int sumOfAllDice = 0;

void setup() {
	// Window size
	size(350, 450);
	// Style initializations
	noStroke();
	rectMode(CENTER);
	textAlign(CENTER, CENTER);
	PFont myFont = createFont("Arial", 32);
	textFont(myFont);
}

void draw() {
	background(200);

	// Display text of sum
	fill(30);
	translate(width / 2, height - 50);
	if(activeDice.size() > 0) {
		textSize(32 * (activeDice.get(0).s / activeDice.get(0).maxS));
		rotate(25 - 25 * (activeDice.get(0).s / activeDice.get(0).maxS));
	}
	else {
		rotate(0);
	}
	text(sumOfAllDice, 0, 0);
	if(activeDice.size() > 0) {
		rotate(-(25 - 25 * (activeDice.get(0).s / activeDice.get(0).maxS)));
	}
	else {
		rotate(-25);
	}
	translate(-(width / 2), -(height - 50));

	for(Die dice : activeDice) { // Draws all active dice
		dice.update();
		dice.show();
	}

	List<Die> tempFallingDice = new ArrayList<Die>();

	for(Die dice : fallingDice) {
		dice.update();
		dice.show();
		if(dice.y <= height + 100) {
			tempFallingDice.add(dice);
		}
	}
	fallingDice.clear();
	fallingDice = tempFallingDice;
}

void mouseClicked() { // Starts the draw loop when mouse is pressed
	sumOfAllDice = 0; // Resets sum
	for(Die dice : activeDice) { // Set all active dice to fall
		dice.setToFall(); // Make the current active dice fall
		// Move the active dice to fall
		fallingDice.add(dice);
	}
	activeDice.clear(); // Clear all dice from the active list
	for(int x = 25; x <= width - 25; x += 30) { // Creates a new grid of active dice
		for(int y = 25; y <= height - 25 - 100; y += 30) {
			activeDice.add(new Die(x, y));
		}
	}
}

class Die { // A single die

	// Die properties
	float x, y; // Position of the die
	double velX, velY, angVel; // Velocity of the die
	float deg = 0; // The rotation of the die in degrees
	float s = 1; // The size of the die
	float growthRate = 1; // The growth rate of the die
	float maxS = 25; // The maximum size of the die
	int num; // The number on the die

	// Die states
	boolean growing = true;
	boolean falling = false;

	// Die previous positions
	float[] prevX = new float[]{-100, -100, -100};
	float[] prevY = new float[]{-100, -100, -100};
	
	Die(int argX, int argY) {
		x = argX;
		y = argY;
		num = (int)(Math.random() * 6 + 1); // Rolls the die a random number
		sumOfAllDice += num; // Update the sum of all dice with the own value
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
			// Save previous position
			prevX[2] = prevX[1];
			prevX[1] = prevX[0];
			prevX[0] = x;
			prevY[2] = prevY[1];
			prevY[1] = prevY[0];
			prevY[0] = y;
			x += velX;
			y += velY;
			deg += angVel;
			velX *= 0.95;
			velY += 0.25;
			angVel *= 0.95;
		}
	}
	void setToFall() { // Set the dice to fall
		falling = true;
		// Set a random velocity of the die when falling
		velX = Math.random() * 20 - 10;
		velY = Math.random() * -10;
		angVel = Math.random() * 20 - 10;
	}
	void show() { // Displays the die
		// Draws trails based on previous positions
		translate(prevX[2], prevY[2]);
		fill(255, 255, 255, 80);
		rect(0, 0, s, s, 5);
		translate(-prevX[2], -prevY[2]);
		translate(prevX[1], prevY[1]);
		fill(255, 255, 255, 80);
		rect(0, 0, s, s, 5);
		translate(-prevX[1], -prevY[1]);
		translate(prevX[0], prevY[0]);
		fill(255, 255, 255, 80);
		rect(0, 0, s, s, 5);
		translate(-prevX[0], -prevY[0]);
		// Draws die
		translate(x, y); // Translates the die to position
		rotate(radians(deg)); // Rotates the die
		fill(255);
		rect(0, 0, s, s, 5);
		fill(40);
		// Draws the die based on the number of dots
		if(num == 1) {
			ellipse(0, 0, 5, 5);
		}
		else if(num == 2) {
			ellipse(-5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS); // Multiplies value by ratio because die grow
			ellipse(5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
		}
		else if(num == 3) {
			ellipse(-5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(0, 0, 5, 5);
			ellipse(5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
		}
		else if(num == 4) {
			ellipse(-5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(-5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
		}
		else if(num == 5) {
			ellipse(-5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(-5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(0, 0, 5, 5);
		}
		else {
			ellipse(-5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(-5 * s / maxS, 5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, -5 * s / maxS, 5 * s / maxS, 5 * s / maxS);
			ellipse(5 * s / maxS, 0, 5 * s / maxS, 5 * s / maxS);
			ellipse(-5 * s / maxS, 0, 5 * s / maxS, 5 * s / maxS);
		}
		rotate(radians(-deg)); // Unrotates the die
		translate(-x, -y); // Untranslates die position
	}
}