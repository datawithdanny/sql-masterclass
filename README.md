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

- [📚 Course Content](#course-content)
- [📊 Accessing the Data](#accessing-the-data)
- [🙏 Conclusion](#thank-you)
- [😎 About the Author](#about-danny)

# 👋 Introduction

This free GitHub course is sorted into multiple tutorials which were actually delivered using O'Reilly Katacoda during the live training (which is totally ah-mazing 🤩 )

To avoid any legal issues - all of the SQL live training material is available directly here on GitHub as a companion course which you can learn from at your leisure 👌

You can also see the presentation slides for the live training [here!](https://github.com/datawithdanny/sql-masterclass/tree/main/slides/sql-masterclass-odsc-apac-2021.pdf)

# 📚 Course Content <a name = "course-content"></a>

Click the navigation badge below to get started - all of the course tutorials can be found in the `/course-content` folder!

**CLICK ON THE BADGE BELOW TO GET STARTED!!!**

[![forthebadge](./images/badges/start-here.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step1.md)

# 📊 Accessing the Data <a name = "accessing-the-data"></a>

Although all of the code examples show the outputs directly inside the training materials for this masterclass, you can also play with the data locally or on a few different hosted services provided below!

My recommendations are to use any one of the `Docker` solutions to best replicate the SQLPad environment used for the actual live training session.

You can also access the free `DB-Fiddle` instances below or you can also access the raw data [here!](#raw-data)

## Docker Solutions

This is the preferred setup to access all of the course data in the desired SQLPad environment!

This same Docker SQLPad interface is featured in the Data With Danny [Serious SQL course](https://www.datawithdanny.com/) but with a lot more data included - you should check it out! 😉

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

Update: There are now SQL scripts for both PostgreSQL and MySQL - however all of the code inside the course contents is for PostgreSQL only.

The majority of the code snippets should still work across SQL flavours but you may need to tweak some of the queries slightly!

* `Postgres/init-postgres.sql` and `MySQL/init-mysql.sql` can be ran with your favourite SQL IDE like PgAdmin4 or MySQL Workbench directly to create the required database tables
* `Postgres/schema-postgres.sql` and `MySQL/schema-mysql.sql` contain the table definitions in case you want to use them also and load in the CSV files
* `.csv` files containing the raw data for each table if you want to import the data to another tool

Note that the two flavour init scripts are essentially the same - but MySQL has backticks instead of double quotes for table creation steps!

---

# Thank You & Next Steps <a name = "next-steps"></a>

Thank you for your taking this free SQL Masterclass GitHub course! If you've enjoyed this - please feel free to share this with your friends and leave a review! ⭐

Here are some ways you can support the author and the Data With Danny team below 🙏

## Data With Danny Virtual Data Apprenticeship

<a href="https://www.datawithdanny.com" target="_blank" rel="noopener noreferrer">
<img src="./course-content/assets/dwd-banner.png">
</a>
<br>

If you're interested in learning valuable data science skills with Danny directly - you can checkout the [Data With Danny](https://www.datawithdanny.com) website for more details!

Join our private student community with over 1,000 data professionals, join a local study group, get help from our team of 12+ data mentors and learn more about our personalized mentorship initiatives!

The 1st part of the Data With Danny program is Serious SQL which is like this SQL course but on an entirely differently level. If you're serious about learning SQL you won't want to miss this course!

Our first live SQL training cohort begins in November 2021 - you can gain all access to course content, recorded videos, our private Discord and more for a one off payment of only $49 - find out more [here!](https://www.datawithdanny.com/courses/serious-sql)

## 8 Week SQL Challenge Case Studies

<a href="www.8weeksqlchallenge.com/getting-started" target="_blank" rel="noopener noreferrer">
<img src="./course-content/assets/8-week-sql-challenge.png">
</a>
<br>

Want to test your SQL skills and tackle 8 realistic SQL case studies and get access to a collection of free SQL learning resources?

Join the Data With Danny [8 Week SQL Challenge](https://www.8weeksqlchallenge.com/getting-started) for free today!

Solve all 8 realistic SQL case studies designed to simulate real work scenarios and interview questions across multiple analytics domains including customer analytics, digital, banking, retail and subscriptions!

## About the Author: Danny Ma <a name = "about-danny"></a>

<a href="https://linktr.ee/datawithdanny" target="_blank" rel="noopener noreferrer">
<img src="./course-content/assets/avatar.png">
</a>

Danny is the Chief Data Mentor at Data With Danny and the Founder & CEO of Sydney Data Science, a boutique data consultancy based out of Sydney, Australia 🇦🇺

After spending the last 10 years working in almost every single role in the data ecosystem, Danny is now focused on solving difficult problems at scale re-imagining data education and recruitment, and mentoring the next generation of data professionals.

He provides specialist data consultancy services:

* Digital customer analytics and experimentation
* Data and machine learning strategy
* Data engineering and systems design
* Team building for analytics and data science functions
* Technical training for practitioners and management

Danny is a regular speaker at global data conferences, meetups and podcasts where he shares the importance of mentorship for all data professionals. He is
also a technical author and instructor for O'Reilly.

Danny believes that he is living proof that dispels the myth that you need higher level education to be successful in the data science space,
and he wants to share his experiences with others so they can do the same.
