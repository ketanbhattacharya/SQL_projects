-- Create characters table
CREATE TABLE characters (
	character_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
	occupation VARCHAR(100),
	catchphrase TEXT
);

-- Insert characters
INSERT INTO characters (name, gender, occupation, catchphrase) VALUES
('Joey Tribbiani', 'Male', 'Actor', 'How you doin\'?'),
('Monica Geller', 'Female', 'Chef', 'Welcome to the real world!'),
('Chandler Bing', 'Male', 'IT Specialist', 'Could I BE any more sarcastic?'),
('Rachel Green', 'Female', 'Fashion Executive', 'Oh. My. God!'),
('Ross Geller', 'Male', 'Paleontologist', 'We were on a break!'),
('Phoebe Buffay', 'Female', 'Musician', 'Smelly Cat, Smelly Cat...'),
('Gunther', 'Male', 'Central Perk Manager', 'Rachel!'),
('Janice Litman', 'Female', 'Unknown', 'Oh. My. God!'),
('Mike Hannigan', 'Male', 'Pianist', 'I like marriage.'),
('Richard Burke', 'Male', 'Ophthalmologist', 'I love Monica.'),
('Emily Waltham', 'Female', 'Englishwoman', 'Ross, I take thee, Rachel...'),
('David', 'Male', 'Scientist', 'I’m going to Minsk.');

-- Create episodes table
CREATE TABLE episodes (
	episode_id SERIAL PRIMARY KEY,
	season INT CHECK (season BETWEEN 1 AND 10),
	episode_number INT CHECK (episode_number > 0),
	title VARCHAR(255) NOT NULL,
	air_date DATE
);

-- Insert episodes
INSERT INTO episodes (season, episode_number, title, air_date) VALUES
(1, 1, 'The One Where Monica Gets a Roommate', '1994-09-22'),
(1, 2, 'The One with the Sonogram at the End', '1994-09-29'),
(1, 3, 'The One with the Thumb', '1994-10-06'),
(1, 4, 'The One with George Stephanopoulos', '1994-10-13'),
(2, 1, 'The One with Ross’s New Girlfriend', '1995-09-21'),
(2, 7, 'The One Where Ross Finds Out', '1995-11-09'),
(3, 25, 'The One at the Beach', '1997-05-15'),
(4, 24, 'The One with Ross’s Wedding: Part 2', '1998-05-07'),
(5, 14, 'The One Where Everybody Finds Out', '1999-02-11'),
(6, 25, 'The One with the Proposal', '2000-05-18'),
(7, 24, 'The One with Monica and Chandler’s Wedding: Part 2', '2001-05-17'),
(8, 24, 'The One Where Rachel Has a Baby: Part 2', '2002-05-16'),
(9, 18, 'The One with the Lottery', '2003-04-03'),
(10, 17, 'The Last One: Part 1', '2004-05-06'),
(10, 18, 'The Last One: Part 2', '2004-05-06');

-- Create character_appearances table
CREATE TABLE character_appearances (
	id SERIAL PRIMARY KEY,
	character_id INT REFERENCES characters(character_id) ON DELETE CASCADE,
	episode_id INT REFERENCES episodes(episode_id) ON DELETE CASCADE
);

-- Insert character appearances
INSERT INTO character_appearances (character_id, episode_id) VALUES
(1, 1), -- Joey in Ep1
(2, 1), -- Monica in Ep1
(3, 1), -- Chandler in Ep1
(4, 1), -- Rachel in Ep1
(5, 1), -- Ross in Ep1
(6, 1), -- Phoebe in Ep1
(1, 5), -- Joey in Ep5
(4, 5), -- Rachel in Ep5
(5, 5), -- Ross in Ep5
(6, 5); -- Phoebe in Ep5

-- Create relationships table (FIXED: Added 'Crush' to allowed values)
CREATE TABLE relationships (
	relationship_id SERIAL PRIMARY KEY,
	character1_id INT REFERENCES characters(character_id) ON DELETE CASCADE,
	character2_id INT REFERENCES characters(character_id) ON DELETE CASCADE,
	relationship_type VARCHAR(50) CHECK (
		relationship_type IN ('Friends', 'Dating', 'Married', 'Siblings', 'Roommates', 'Crush', 'Parents')
	),
	start_season INT,
	end_season INT
);

-- Insert relationships
INSERT INTO relationships (character1_id, character2_id, relationship_type, start_season, end_season) VALUES
(1, 3, 'Roommates', 1, 6),  -- Joey & Chandler were roommates
(2, 3, 'Dating', 5, 5),  -- Monica & Chandler dated in Season 5
(2, 3, 'Married', 7, 10),  -- Monica & Chandler got married in Season 7
(4, 5, 'Dating', 2, 3),  -- Rachel & Ross dated in Seasons 2-3
(4, 5, 'Married', 5, 6),  -- Rachel & Ross got married briefly
(4, 5, 'Parents', 8, 10),  -- Rachel & Ross became co-parents in Season 8
(2, 5, 'Siblings', 1, 10),  -- Monica & Ross are siblings
(6, 9, 'Married', 9, 10),  -- Phoebe & Mike got married in Season 9
(1, 4, 'Dating', 8, 8),  -- Joey & Rachel briefly dated in Season 8
(7, 4, 'Crush', 1, 10);  -- Gunther had a crush on Rachel


-- 1) Get all characters in the show ?
	select * from characters;
    
-- 2) Get all episode titles and their air dates ?
select title,air_date from episodes
order by air_date;

-- 3) Find Joey Tribbiani’s occupation ?
select name,occupation
from characters
where name = 'Joey Tribbiani';

-- 4) Find how many episodes each character has appeared in ?
select c.name, COUNT(ca.episode_id) AS episode_count
from characters c
join character_appearances ca on c.character_id = ca.character_id
group by c.name
order by count(ca.episode_id) desc;

-- 5) Find the highest number of characters appearing in a single episode ?

select count(ca.character_id) as character_count,ep.title
from character_appearances ca
join episodes ep on ep.episode_id = ca.episode_id
group by ep.title
order by character_count desc
limit 1;

-- 6) Find all episodes that aired between 1998 and 2002 ?
select title,air_date
from episodes
where air_date between '1998-01-01' and '2002-01-01'
order by air_date;

-- 7) Find all characters whose name starts with ‘J’ ?
select name
from characters
where name like 'J%';

-- 8) Find all episodes from season 5 or season 6 ?
select title, season, episode_number
from episodes
where season in (5, 6)
order by season, episode_number;

-- 9) Find the first and last episode of each season ?
(
  SELECT season, episode_number, title, air_date
  FROM episodes
  WHERE (season, episode_number) IN (
    SELECT season, MIN(episode_number)
    FROM episodes
    GROUP BY season
  )
)
UNION
(
  SELECT season, episode_number, title, air_date
  FROM episodes
  WHERE (season, episode_number) IN (
    SELECT season, MAX(episode_number)
    FROM episodes
    GROUP BY season
  )
)
ORDER BY season, episode_number;

-- 10) Find all female characters in the show ?
select name
from characters
where gender = 'Female';