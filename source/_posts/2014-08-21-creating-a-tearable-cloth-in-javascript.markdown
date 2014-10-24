---
layout: post
title: "Creating a Tearable Cloth in Javascript"
date: 2014-08-21 23:35
comments: true
categories: Javascript Animations 2D Physics Engine
---

One of the things that I have been very interested in but never got around to learning has been animations. I find them fascinating, I think every person who grew up playing games does,  and I have been eager to find the best entry point into that world. Then I saw @suffick's tearable cloth. After playing around with it for a crazy amount of time, I started checking out the code. 300 lines of well written javascript and no external libraries. A basic physics engine that simulates a cloth. I will now explain in detail how it all works. 
[The Tearable Cloth](http://codepen.io/suffick/pen/KrAwx?editors=101)
<!-- more --> 

So it all starts with the ```<canvas id=“c”></canvas>``` element in the html. Thats the only html you need and then you can let the javascript do the work. Oh and you dont need any CSS either; dont you love it when things are simple? 
The ```<canvas>``` tag is used to draw graphics in the browser with javascript. 
When the program loads we need to do some simple configurations to the canvas element. 
    window.onload = function(){
      canvas = document.getElementById(‘c’);
      ctx = canvas.getContext(‘2d’);
      canvas.width = 560;
      canvas.height = 350;
      start();
    };
The canvas variable is set to the \<canvas\> element by finding it by Id. We then are able to give it properties by calling the getContext method on it and telling it that its a 2d plane. Lastly we set the height and width of the canvas. Once we are done with the configurations we call the start function.

## Mouse Object

Now before we go in to the start function, I will quickly talk about the mouse object which will be used in the start function. 

    mouse = {
        down: false,
        button: 1,
        x: 0,
        y: 0,
        px: 0,
        py: 0
    };
The mouse object saves the state of the mouse which gets updated when a new mouse event occurs such as when it moves or is clicked. The mouse saves whether it was clicked, which button was clicked, the x and y coordinates and the past x and y coordinates. Cool, now we have all we need to know for the start function. 
    
## Start Function
    function start() {
    
        canvas.onmousedown = function (e) {
            mouse.button = e.which;
            mouse.px = mouse.x;
            mouse.py = mouse.y;
            var rect = canvas.getBoundingClientRect();
            mouse.x = e.clientX - rect.left,
            mouse.y = e.clientY - rect.top,
            mouse.down = true;
            e.preventDefault();
        };
    
        canvas.onmouseup = function (e) {
            mouse.down = false;
            e.preventDefault();
        };
    
        canvas.onmousemove = function (e) {
            mouse.px = mouse.x;
            mouse.py = mouse.y;
            var rect = canvas.getBoundingClientRect();
            mouse.x = e.clientX - rect.left,
            mouse.y = e.clientY - rect.top,
            e.preventDefault();
        };
    
        canvas.oncontextmenu = function (e) {
            e.preventDefault();
        };
    
        boundsx = canvas.width - 1;
        boundsy = canvas.height - 1;
    
        ctx.strokeStyle = '#888';
        cloth = new Cloth();
        update();
    }
These functions are called whenever a specific event occurs. In the first function, whenever the canvas detects that the mouse is down it is called and provided the input 'e' which is the event. What we are doing here is saving information from the event into our mouse object. We first save which mouse button was clicked, then move mouse.x and mouse.y to mouse.px and mouse.py which is short for mouse.previousx. The event gives us x and y coordinates, but it gives them relative to the whole screen rather than relative to the canvas which is what we want. We therefore need to get the coordinates of the canvas using ```var rect = canvas.getBoundingClientRect();``` and then getting the relative coordinates from there.  ```mouse.x = e.clientX - rect.left```. Lastly, we say that the mouse is down and to prevent the default behaviour. The default behaviour it is talking about is when you right click on your browser it gives you a popup where you can go back or save as and so on but when you are creating a game or animation you don't want that.

The rest of the methods are pretty similar. They just take the mouse event and save it to the mouse object we created so that we have the state of the mouse saved. 

At the bottom of the start() function we save the boundsx and boundsy as one less than the height and width of the canvas since we start counting from 0 and we need to know the range of the canvas. Ctx (short for context) was given to us by the browser once we told it that this canvas was in 2 dimentions. With ctx we can now draw a line from a certain point to another point. First though, we need to set what color those lines will be with ```strokeStyle()```. To finish off this function we create a new Cloth() and then call ```update()```. Update is an infinite loop that keeps calling itself. 

## Creating a new Cloth
Lets move on to the code that describes the Cloth.

    var Cloth = function () {

        this.points = [];
        var start_x = canvas.width / 2 - cloth_width * spacing / 2;

        for (var y = 0; y <= cloth_height; y++) {
            for (var x = 0; x <= cloth_width; x++) {

                var p = new Point(start_x + x * spacing, start_y + y * spacing);

                (x != 0) && p.attach(this.points[this.points.length - 1]);
                (y == 0) && p.pin(p.x, p.y);
                (y != 0) && p.attach(this.points[x + (y - 1) * (cloth_width + 1)])

                this.points.push(p);
            }
        }
    };

Basically the Cloth object is a grid of Points that have regular spacing between them. Each point is connected by lines with the points above, below, to the left and to the right of it. We create an empty array to store the points and then calculate the start_x to know where to begin placing the points in the cloth so that the cloth is always in the middle of the canvas. ( We also have a start_y but we set that to always be 20px below the top of the canvas in the settings). In this case we have the canvas width set to 560 pixels , and the cloth_width to be 50 Points across and the spacing between the Points to be 7 pixels. 

We then have a double For loop that iterates through the columns and rows. We initialise a new point at each iteration and tell it its coordinates. As well as telling the point its location, we also need to tell it which other points it is attached to or if it is pinned on the board which is the case for the top row (y == 0) since they are connected to a certain point on the canvas. 

If it is not in the first column, we know that the Point is connected to the Point created previously (the one to its left) and if it is not in the first row then we know it is connected to the point above it. After we create the point and attach/pin it we then push it into the points array. 

Now that we have created the Cloth we can go into the update() function. 

## Update Function

    function update() {

        ctx.clearRect(0, 0, canvas.width, canvas.height);
        cloth.update();
        cloth.draw();
        requestAnimFrame(update);
    }
The first thing that happens when we update is that the whole canvas is cleared of any lines drawn on it. If we didn't clear it every time the lines would show not only where they are supposed to be now but where they were in the past as well. 

cloth.update() calculates the new values of all of the points in the program and cloth.draw actually draws the lines on the canvas. I will explain the update and draw functions later, first I will explain what the requestAnimFrame(update) does. 

## requestAnimFrame
For animations and graphics we need things to happen at a regular time interval. To make our animations 60 frames per second, we could make a time loop that calls update() every 17 milliseconds (1000/60). This kind of thing is pretty common so browsers have given programmers an API that does this for them. Of course, browsers being browsers, havent agreed on a common API so we need the following code to be compatible with all of them. 

    window.requestAnimFrame =
        window.requestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame ||
        window.oRequestAnimationFrame ||
        window.msRequestAnimationFrame ||
        function (callback) {
            window.setTimeout(callback, 1000 / 60);
    };

```requestAnimFrame()``` has several advantages. If we had the animation running off of a time loop then it would keep running even if the animation was in another tab that was not visible to the user. By using the browser's API they wont run it when the user can't see it. This saves the users battery. 

## Cloth.prototype.update

Now we are getting into the meat of the program. 

    Cloth.prototype.update = function () {

        var i = physics_accuracy;

        while (i--) {
            var p = this.points.length;
            while (p--) this.points[p].resolve_constraints();
        }

        i = this.points.length;
        while (i--) this.points[i].update(.016);
    };

Physics accuaracy is the name of the variable that tells the program how many times to run resolve constraints for each of the points. What this changes on a high level is it changes how elastic the cloth is. In the code it dictates how many times the resolve constraints method is called on each of the points. The resolve constraints method takes into account the forces applied to each of the points and tells it where it will move to in the next frame. For example, if a point is in the middle of the cloth and is not moving then that point has several forces acting upon it. Its got the force of gravity pushing it downwards. It also has the point above it pushing it upwards. We need to resolve these forces and then the net of them will dictate where it will move to. We will go into the exact code for this next. Once we have calculated the forces on each of the points we can then update them. 

## Resolving Constraints on Points

    Point.prototype.resolve_constraints = function () {

        if (this.pin_x != null && this.pin_y != null) {

            this.x = this.pin_x;
            this.y = this.pin_y;
            return;
        }

        var i = this.constraints.length;
        while (i--) this.constraints[i].resolve();

        if (this.x > boundsx) {

            this.x = 2 * boundsx - this.x;
            
        } else if (this.x < 1) {

            this.x = 2 - this.x;
        }

        if (this.y > boundsy) {

            this.y = 2 * boundsy - this.y;
            
        } else if (this.y < 1) {

            this.y = 2 - this.y;
        }
    };
The first thing we check is if the point is pinned on the board. If it is, then we set its x and y coordinates to those of the pin and return. A pinned point can not move. 

We then go through all of the constraints for that point and calculate their effect on it. This is done by first calculating the distance of the attached neighbouring point. If the distance is greater than a certain length that we set as the tear_distance then the cloth tears and they are no longer attached (and we remove that point as a constraint)

Otherwise, we calculate the diff which is the difference between what the natural spacing of the cloth is supposed to be (set here as 7px) and what it is in reality. So if the cloth is squashed together, the distance between the points will be less than 7px and there will be a force on the points to push the points outwards to get their spacing back to 7. 
Alternatively, if the cloth is being stretched, then the distance between the points will be greater than their natuaral 7px and they will want to move closer together. The diff is halved since the two points will both move to reach equilibrium and they only need to travel half the distance to get there. This updates the value of the constraint to the coordinate that it is pushing the point towards. 


    Constraint.prototype.resolve = function () {

        var diff_x = this.p1.x - this.p2.x,
            diff_y = this.p1.y - this.p2.y,
            dist = Math.sqrt(diff_x * diff_x + diff_y * diff_y),
            diff = (this.length - dist) / dist;

        if (dist > tear_distance) this.p1.remove_constraint(this);

        var px = diff_x * diff * 0.5;
        var py = diff_y * diff * 0.5;

        this.p1.x += px;
        this.p1.y += py;
        this.p2.x -= px;
        this.p2.y -= py;
    };

So we go through and resolve all of our constraints. If a point is connected to four points, it means it has four constraints. Some of its neighbours might by pushing or pulling it, and others might not have any effect on it. When we are finished looping through the constraints the px and py of our point will represent the coordinate where it ended up after all of that. 

We then go on to check if the location we ended up in is in the visible canvas area. The effect of the tearable cloth when it goes off of the screen is that it bounces back. Say area we are allowed in was between 0 and 100 and we managed to go to 120. To bounce back, we say 2*100 - 120 = 80. Similarly, if we escape out of bounds to the left and go to -20, we say 2*0 - (-20) = 20 and we have bounced back into our grid. 

## Updating the Points Location

Once we have done that, we have finished resolving the constraints. We now know where each of the points neighbours are pushing. We arent finished adding up all of the forces though. As well as the pesky neighbouring points pushing it in different directions, we cant forget the gravitational force pushing it down and of course the mouse we control. 

    Point.prototype.update = function (delta) {

        if (mouse.down) {

            var diff_x = this.x - mouse.x,
                diff_y = this.y - mouse.y,
                dist = Math.sqrt(diff_x * diff_x + diff_y * diff_y);

            if (mouse.button == 1) {

                if (dist < mouse_influence) {
                    this.px = this.x - (mouse.x - mouse.px) * 1.8;
                    this.py = this.y - (mouse.y - mouse.py) * 1.8;
                }

            } else if (dist < mouse_cut) this.constraints = [];
        }

        this.add_force(0, gravity);

        delta *= delta;
        nx = this.x + ((this.x - this.px) * .99) + ((this.vx / 2) * delta);
        ny = this.y + ((this.y - this.py) * .99) + ((this.vy / 2) * delta);

        this.px = this.x;
        this.py = this.y;

        this.x = nx;
        this.y = ny;

        this.vy = this.vx = 0
    };

So here we check if the mouse is being pressed down and if yes, we calculate the distance of the mouse to the point. We have a variable called mouse_influence that tells us the radius away from the mouse that points are affected. We need this since a mouse is clicked on a single pixel and most likely it would miss any of the points on the board. By having a mouse influence we can choose distance away from the mouse that the points get affected. If the right mouse button is clicked, it means we are cutting the cloth and so we get rid of the constraints (connecting lines) of those points. 
If the left mouse button is held down and moving then we want to push the cloth along at the same velocity as the mouse. The velocity of the cloth, is the current (x and y) minus the previous location (px and py) over a time period and this is equal to the mouse velocity of its current location minus its previous location. The time constant of 1.8 is there because of the lag between the mouse and the cloth. 

## Adding Gravity
Adding the effect of gravity to the cloth is surprisingly simple. We save the gravity to vx and vy which will be used as the acceleration in the verlet integration formula. 
    Point.prototype.add_force = function (x, y) {
        this.vx += x;
        this.vy += y;
    };

## Verlet Integration

    delta *= delta;
    nx = this.x + ((this.x - this.px) * .99) + ((this.vx / 2) * delta);
    ny = this.y + ((this.y - this.py) * .99) + ((this.vy / 2) * delta);

We then have these complex looking formulas. You may think, we have the coordinates x and y where we will travel to. Why do we need to calculate nx and ny? Well, if we simply updated our coordinates to the new location, we would simply teleport to a new spot which is not what we want. We need to take into account where our current location is now and take a baby step in the direction we are being pushed to. Also, what if we were already moving in a certain direction with a certain speed? We arent going to simply freeze and relocate at the new location. Because of inertia (and the other laws of physics) the more realistic behaviour is to update the new location of the point after looking at where the point is now and applying some force depending on the constrains and gravity and mouse push as well as its velocity from before and then take a step in that direction. This is all calculated using the verlet integration in that formula. 

You can read a bunch of things online about verlet integration. Its the discrete time series formula for the physics laws that describe momentum. 

![derivation for equations of motions](http://upload.wikimedia.org/math/3/b/8/3b830a1aeefb29ad7c2c7b32e66beeff.png)
To show how we get the continuous time version, we get the velocity by integrating the acceleration by time. To get the location, we integrate the velocity. The result we get is that the new location is equal to the old location + velocity * time + 0.5 * acceleration * time^2. 

The discrete time version of this is pretty analogous to the one before. (I'll be disappointed if anyone doesn't catch that)

![Verlet Integration](http://upload.wikimedia.org/math/e/b/2/eb28fb612c162ab9fa15686bf2e63903.png)

As we can see, this formula is the same as the one written in the code. deltaTi/deltaTi-1 is approximately 0.99 and we multiply the acceleration by (delta^2)/2. 
Keep in mind that just by its nature, discrete time formulas like this are approximations. Pretty much everything in my engineering degree was an approximation. 

## Drawing Points
Having finished the verlet integration we now have the new x and y coordinates for each of the points. That was the ```cloth.update()``` step. The next step in the ```update()``` method is ```cloth.draw()```.

    Cloth.prototype.draw = function () {
     
        ctx.beginPath();
    
        var i = cloth.points.length;
        while (i--) cloth.points[i].draw();
     
        ctx.stroke();
    };
What this does is calls ```beginPath()``` on the 2d canvas. This tells the browser to start paying attention since we are going to start telling it what to draw. It will then cycle through each of the points and call the draw method on them. These will be a series of moveTo() and lineTo() calls which is just telling the javascript there will be a line from here to here. 
Once we are done looping through the points, we call ```stroke()``` which is equivalent to 'now draw everything'.

    Constraint.prototype.draw = function () {
    
        ctx.moveTo(this.p1.x, this.p1.y);
        ctx.lineTo(this.p2.x, this.p2.y);
    };

Once we are done drawing, it will then call requestAnimFrame which will call update again when its time to draw the next frame. 

## Conclusions

And that is all there is to creating your own tearable cloth in javascript. Its a great introduction to animations and how physics engines work. Of course the 3d stuff gets a lot harder with a lot more math and with a lot more than 300 lines of code, but thats something for another day. I hope you enjoyed this as much as I have, and please don't hesitate to contact me if you have any comments and questions @mpolycar.  
