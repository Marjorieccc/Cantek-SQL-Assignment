--subscriptionPlan
CREATE TABLE subscriptionPlan (
    planID SERIAL PRIMARY KEY,
    planName VARCHAR(30) NOT NULL, 
    planDesc VARCHAR(100) NOT NULL, 
    planPrice NUMERIC(5,2) NOT NULL,
    subsDuration INT NOT NULL,
    CONSTRAINT planID_chk CHECK (planID ~ '^S....')
); 

--discount
CREATE TABLE discount (
    discountID SERIAL PRIMARY KEY,
    discountName VARCHAR(40) NOT NULL, 
    discountDesc VARCHAR(100) NOT NULL, 
    discountValue NUMERIC(2,2) NOT NULL,
    promoCode VARCHAR(20), 
    discountStartDay DATE NOT NULL,
    discountEndDay DATE NOT NULL,
    CONSTRAINT dis_discountID CHECK (discountID ~ '^D....')
); 

--user 
CREATE TABLE userAccount (
    userID SERIAL PRIMARY KEY,
    planID SERIAL NOT NULL,
    userName VARCHAR(25) NOT NULL, 
    passwordHash VARCHAR(50) NOT NULL, 
    email VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    expDateSubs DATE NOT NULL , 
    CONSTRAINT us_userID_chk CHECK (userID ~ '^U....'),
    CONSTRAINT us_planID_chk CHECK (planID ~ '^S....'),
    CONSTRAINT us_planID_fk FOREIGN KEY (planID) REFERENCES subscriptionPlan(planID),
    CONSTRAINT us_email_chk CHECK (email ~ '^.+@.+\..+$')
); 

--profile
CREATE TABLE profileAccount (
    profileID SERIAL PRIMARY KEY,
    profileName VARCHAR(25) NOT NULL, 
    profileDOB DATE NOT NULL, 
    gender VARCHAR(2), 
    CONSTRAINT pro_profileID_chk CHECK (profileID ~ '^P....'),
    CONSTRAINT pro_gender_chk CHECK (gender IN ('M', 'F', 'NA') OR gender IS NULL)
); 

--userProfile
CREATE TABLE userProfile (
    userID SERIAL NOT NULL,
    profileID SERIAL NOT NULL,
    PRIMARY KEY(userID, profileID),
    CONSTRAINT up_userID_chk CHECK (userID ~ '^U....'),
    CONSTRAINT up_profileID_chk CHECK (profileID ~ '^P....'),
    CONSTRAINT up_userID_FK FOREIGN KEY (userID) REFERENCES userAccount(userID),
    CONSTRAINT up_profileID_FK FOREIGN KEY (profileID) REFERENCES profileAccount(profileID)
); 

--genre
CREATE TABLE genre (
    genreID SERIAL PRIMARY KEY,
    genreDesc VARCHAR(25) NOT NULL, 
    CONSTRAINT ge_genreID_chk CHECK (genreID ~ '^G....')
); 

--director
CREATE TABLE director (
    directorID SERIAL PRIMARY KEY,
    firstname VARCHAR(25) NOT NULL, 
    lastname VARCHAR(25) NOT NULL, 
    gender VARCHAR(2),
    CONSTRAINT dir_directorID_chk CHECK (directorID ~ '^D....'),
    CONSTRAINT dir_gender_chk CHECK (gender IN ('M', 'F', 'NA') OR gender IS NULL)
); 

--movie
CREATE TABLE movie (
    movieID SERIAL PRIMARY KEY,
    directorID SERIAL NOT NULL,
    movieName VARCHAR(100) NOT NULL, 
    yearOfRelease INTEGER NOT NULL, 
    mvLanguage VARCHAR(3) NOT NULL,
    country VARCHAR(3) NOT NULL,
    mvDuration INTEGER NOT NULL,
    minAge INTEGER NOT NULL,
    quality VARCHAR(5) NOT NULL,
    CONSTRAINT mv_movieID_chk CHECK (movieID ~ '^M....'),
    CONSTRAINT mv_directorID_chk CHECK (directorID ~ '^D....'),
    CONSTRAINT mv_yearOfRelease_chk CHECK (yearOfRelease > 1894),
    CONSTRAINT mv_minAge_chk CHECK (minAge >= 0),
    CONSTRAINT mv_directorID_FK FOREIGN KEY (directorID) REFERENCES director(directorID)
); 

--genreMovie
CREATE TABLE genreMovie (
    genreID SERIAL NOT NULL,
    movieID SERIAL NOT NULL,
    PRIMARY KEY(genreID, movieID),
    CONSTRAINT gp_genreID_chk CHECK (genreID ~ '^G....'),
    CONSTRAINT gp_movieID_chk CHECK (movieID ~ '^M....'),
    CONSTRAINT gp_genreID_FK FOREIGN KEY (genreID) REFERENCES genre(genreID),
    CONSTRAINT gp_movieID_FK FOREIGN KEY (movieID) REFERENCES movie(movieID)
); 

--movieProfile
CREATE TABLE movieProfile (
    movieID SERIAL NOT NULL,
    profileID SERIAL NOT NULL,
    dateWatched DATE NOT NULL,
    userRating INTEGER,
    PRIMARY KEY(movieId, profileID),
    CONSTRAINT mp_movieID_chk CHECK (movieID ~ '^M....'),
    CONSTRAINT mp_profileID_chk CHECK (profileID ~ '^P....'),
    CONSTRAINT mp_userRating_chk CHECK (userRating BETWEEN 1 AND 5),
    CONSTRAINT mp_movieId_FK FOREIGN KEY (movieId) REFERENCES movie(movieId),
    CONSTRAINT mp_profileID_FK FOREIGN KEY (profileID) REFERENCES profileAccount(profileID)
); 

--transactionHistory
CREATE TABLE transactionHistory (
    transID SERIAL PRIMARY KEY NOT NULL,
    userID SERIAL NOT NULL,
    planID SERIAL NOT NULL, 
    discountID VARCHAR(5), 
    amount NUMERIC(10,2) NOT NULL,
    transDate DATE NOT NULL,
    transType VARCHAR(2) NOT NULL,
    CONSTRAINT tr_transID_chk CHECK (transID ~ '^T....'),
    CONSTRAINT tr_userID_chk CHECK (userID ~ '^U....'),
    CONSTRAINT tr_planID_chk CHECK (planID ~ '^S....'),
    CONSTRAINT tr_discountID CHECK (discountID ~ '^D....'),
    CONSTRAINT tr_userID_FK FOREIGN KEY (userID) REFERENCES userAccount(userID),
    CONSTRAINT tr_planID_FK FOREIGN KEY (planID) REFERENCES subscriptionPlan(planID),
    CONSTRAINT tr_discountID_FK FOREIGN KEY (discountID) REFERENCES discount(discountID),
    CONSTRAINT tr_transType_chk CHECK (transType IN ('CR', 'DE'))
); 


