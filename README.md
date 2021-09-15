<p align="center">
    <img src="images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

---

**Welcome to the SQL Masterclass Free GitHub Course!!!**

You can find all of the content and slides for Danny Ma's SQL Masterclass held at the ODSC Asia Pacific 2021 virtual conference!

# Table of Contents

- [Introduction](#introduction)
- [Course Content](#course-content)
- [Accessing The Data](#accessing-the-data)

# 👋 Introduction

This free GitHub course is sorted into multiple tutorials which were actually delivered using O'Reilly Katacoda during the live training (which is totally ah-mazing 🤩 )

To avoid any legal issues - all of the SQL live training material is available directly here on GitHub as a companion course which you can learn from at your leisure 👌

You can also see the presentation slides for the live training [here!](https://github.com/datawithdanny/sql-masterclass/tree/main/slides/sql-masterclass-odsc-apac-2021.pdf)

# Course Content <a name = "course-content"></a>

Click the navigation badge below to get started - all of the course tutorials can be found in the `/course-content` folder!

**CLICK ON THE BADGE BELOW TO GET STARTED!!!**

[![forthebadge](./images/badges/start-here.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step1.md)

# Accessing The Data <a name = "accessing-the-data"></a>

Although all of the code examples show the outputs directly inside the training materials for this masterclass, you can also play with the data locally or on a few different hosted services provided below!

My recommendations are to use any one of the `Docker` solutions to best replicate the SQLPad environment used for the actual live training session.

You can also access the free `DB-Fiddle` instances below or you can also access the raw data [here!]](#raw-data)

## Docker Solutions

This is the preferred setup to access all of the course data in the desired SQLPad environment!

This same Docker SQLPad interface is featured in the Data With Danny [Serious SQL course](https://www.datawithdanny./com) but with a lot more data included - you should check it out! 😉

We even include instructions on how to install Docker if you haven't used it before inside the course :)

### Docker Compose 

If you have Docker installed on your machine with Docker-Compose, you can directly use the `docker-compose.yml` file included in the root of this repo to spin up the required SQLPad infrastructure.

```bash
docker-compose up
```

Once the initialisation is complete - you can visit `localhost:3000` in your favourite browser to access the SQL interface with all the data ready to go.

Note that you may want to save all of your code in a separate text editor and copy & paste it directly into the SQLPad so you don't lose all of your code should something go wrong! 🥵

### Free Play With Docker Instance <a name = "play-with-docker"></a>

You can use this live Docker PostgreSQL environment to copy and paste SQL code from the `code/` folder directly here to see the outputs generated for the session.

Click on the buttons below to launch a Play-With-Docker stack - DockerHub login/signup is required but all batteries should be included.

It's totally free to create your own DockerHub account and highly recommended too if you want to create your own Docker images in the future!

**👇👇👇 Make sure you right click and open the link in a new tab if you're viewing this on GitHub!**

[![Try in PWD](images/badges/sql-interface-play-with-docker.svg)](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/datawithdanny/sql-masterclass/main/docker-compose.yml)

Once the initialisation steps are complete and you see `Your session is ready at the bottom of the screen` - there is a chance you might need to refresh your browser or click just outside the initial popout window and press your esc key to close this window as the `Close` button is sometimes not working!

Next you can either hit port `3000` to use a SQLPad GUI or you can run the following to enter a `psql` terminal instance if you are so inclined!

```bash
docker exec -it `docker ps -aqf "expose=5432"` psql -U postgres
```

### Local Docker Commands

If you are happy to use the `psql` shell instead of the SQLPad GUI because you love the terminal - you can simply run the following commands to access the data directly too. By default, port `5432` will be used for the PostgreSQL database.

Feel free to change the `name` argument to anything you like!

```bash
docker run -d --rm --name="psql-masterclass" dannyma/psql-crypto:latest
docker exec -it psql-masterclass psql -U postgres
```

## DB Fiddle <a name = "db-fiddle"></a>

You can also access the raw data directly in a live browser interface called DB Fiddle.

Click on the badge below to get access to this free service - it takes a little bit longer to run each query when compared to the Docker solutions, so please keep this in mind!

[![forthebadge](images/badges/sql-interface-db-fiddle.svg)](https://www.db-fiddle.com/f/cnLCK4ChsNfr5ViG6vzePg/7)

## Raw Data <a name = "raw-data"></a>

You can also find all of the raw data inside the `/data` folder

[![forthebadge](images/badges/raw-data.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/data)

* `init.sql` to generate all the required data inside PostgreSQL, simply copy and paste the contents and run
* `schema.sql` with the table definitions in case you want to use another SQL flavour
* `.csv` files containing the raw data for each table if you want to import the data to another tool

# Thanks!

Please help me by starring this repo and sharing it with your friends! ⭐️⭐️⭐️

You can also find out more about the Data With Danny virtual data apprenticeship program and more of my free training content [here!](https://bit.ly/dwd-info)

<a href="https://bit.ly/dwd-info" target="_blank" rel="noopener noreferrer">
<img src="./course-content/assets/dwd-banner.png"
</a>
