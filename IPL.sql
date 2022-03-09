Show databases;
create database IPL;
use IPL;

/* Entity Tables */
/* Table 1 */
create table if not exists players (p_id varchar(4) primary key,
                                    p_name varchar(50) not null,
                                    salary_in_cr float(20) not null,
                                    cap_id varchar(4),
                                    p_type ENUM('Batsman', 'Bowler', 'Keeper', 'Keeper/Batsman') not null
                                    );
                                    
insert into players values ('P101', 'Virat Kohli', 17, 'C101', 1);
insert into players(p_id, p_name, salary_in_cr, p_type) values ('P102', 'A.B. De Villiers', 11, 1);
insert into players values ('P103', 'V.S. Dhoni', 15, 'C103', 4);
insert into players values ('P104', 'Dale Steyn', 8, 'C104', 2);

/* Table 2 */
create table if not exists players_performance (perf_id varchar(4) primary key,
                                                matches_no int,
                                                runs int,
                                                wickets int DEFAULT(0)
                                                );
                                                
insert into players_performance values ('VK18', 207, 6283, 4);
insert into players_performance(perf_id, matches_no, runs) values ('AB10', 184, 5162);
insert into players_performance(perf_id, matches_no, runs) values ('MS07', 220, 4746);
insert into players_performance values ('DS09', 95, 167, 97);

/* Table 3 */
create table if not exists teams (t_id varchar(4) primary key,
                                  t_name varchar(20) not null
                                  );
                                  
insert into teams values ('T101', 'Chennai');
insert into teams values ('T102', 'Delhi');
insert into teams values ('T103', 'Bangalore');
insert into teams values ('T104', 'Punjab');

/* Table 4 */
create table if not exists game (matches_id varchar(3) primary key,
                                 win int DEFAULT(0),
                                 loss int DEFAULT(0)
                                 );
                                 
insert into game values ('M1', 10, 4);
insert into game values ('M2', 12, 2);
insert into game values ('M3', 11, 3);
insert into game values ('M4', 9, 5);

/* Table 5 */ 
create table if not exists owner (owner_id varchar(4) primary key,
                                  budget_in_cr int DEFAULT(90),
                                  spent_amt_in_cr float not null
                                  );
                                  
insert into owner(owner_id, spent_amt_in_cr) values ('O101', 87.05); 
insert into owner(owner_id, spent_amt_in_cr) values ('O102', 89.9); 
insert into owner(owner_id, spent_amt_in_cr) values ('O103', 88.45); 
insert into owner(owner_id, spent_amt_in_cr) values ('O104', 89.55); 

/* Relationship Tables */
/* Table 6 */
create table if not exists rel_team_owner (t_id varchar(4) not null,
                                           owner_id varchar(4) not null,
                                           t_name varchar(20) not null,
                                           budget_in_cr int DEFAULT(90),
                                           spent_amt_in_cr float not null,
                                           primary key (t_id, owner_id),
                                           foreign key (t_id) references teams(t_id),
                                           foreign key (owner_id) references owner(owner_id)
                                           );
                                           
insert into rel_team_owner(t_id, owner_id, t_name, spent_amt_in_cr) values ('T101', 'O101', 'Chennai', 87.05);
insert into rel_team_owner(t_id, owner_id, t_name, spent_amt_in_cr) values ('T102', 'O102', 'Delhi', 89.9);
insert into rel_team_owner(t_id, owner_id, t_name, spent_amt_in_cr) values ('T103', 'O103', 'Bangalore', 88.45);
insert into rel_team_owner(t_id, owner_id, t_name, spent_amt_in_cr) values ('T104', 'O104', 'Punjab', 89.55);

/* Table 7 */
create table if not exists rel_player_team (p_id varchar(4) not null,                                           
                                            p_name varchar(50) not null,
                                            salary_in_cr float(20) not null,
                                            cap_id varchar(4),
                                            p_type ENUM('Batsman', 'Bowler', 'Keeper', 'Keeper/Batsman') not null,
                                            t_id varchar(4) not null,
                                            primary key (p_id, t_id),
                                            foreign key (p_id) references players(p_id),
                                            foreign key (t_id) references teams(t_id)
                                            );
                                            
insert into rel_player_team values ('P101', 'Virat Kohli', 17, 'C101', 1, 'T101');
insert into rel_player_team(p_id, p_name, salary_in_cr, p_type, t_id) values ('P102', 'A.B. De Villiers', 11, 1, 'T102');
insert into rel_player_team values ('P103', 'M.S. Dhoni' , 15, 'C103', 4, 'T103');
insert into rel_player_team values ('P104', 'Dale Steyn', 8, 'C104', 2, 'T104');
                                            
/* Table 8 */
create table if not exists rel_game_team (matches_id varchar(3) not null,
                                          t_id varchar(4) not null,
                                          primary key (matches_id, t_id),
                                          foreign key (matches_id) references game(matches_id),
                                          foreign key (t_id) references teams(t_id)
                                          );
                                          
insert into rel_game_team values ('M1', 'T101');
insert into rel_game_team values ('M2', 'T102');
insert into rel_game_team values ('M3', 'T103');
insert into rel_game_team values ('M4', 'T104');
                          
/* Table 9 */                                
create table if not exists rel_player_player_performance (p_id varchar(4) not null,
                                                          perf_id varchar(4) not null,
                                                          primary key (p_id, perf_id),
                                                          foreign key (p_id) references players(p_id),
                                                          foreign key (perf_id) references players_performance(perf_id)
                                                          );
                                                        
insert into rel_player_player_performance values ('P101', 'VK18');
insert into rel_player_player_performance values ('P102', 'AB10');
insert into rel_player_player_performance values ('P103', 'MS07');
insert into rel_player_player_performance values ('P104', 'DS09');


/* Users Created */
create user 'srk'@'localhost' identified by 'srk';
create user 'virat'@'localhost' identified by 'virat';
create user 'ganguly'@'localhost' identified by 'ganguly';
create user 'tata'@'localhost' identified by 'tata';
                                                        
/* Granting Privileges to users */

/* Team Owner */
GRANT select on IPL.* to 'srk'@'localhost';
GRANT insert,delete,update on IPL.owner to 'srk'@'localhost';
GRANT insert,delete,update on IPL.rel_team_owner to 'srk'@'localhost';

/* Player */
GRANT select on IPL.players to 'virat'@'localhost';
GRANT select on IPL.teams to 'virat'@'localhost';
GRANT select on IPL.game to 'virat'@'localhost';
GRANT select on IPL.players_performance to 'virat'@'localhost';
GRANT select on IPL.rel_player_player_performance to 'virat'@'localhost';
GRANT select on IPL.rel_player_team to 'virat'@'localhost';
GRANT select on IPL.rel_game_team to 'virat'@'localhost';

/* BCCI President */
GRANT all privileges on IPL.* to 'ganguly'@'localhost' with GRANT option;

/* Sponsors */
GRANT select on IPL.* to 'tata'@'localhost';

/* Script to Create Backup */
mysqldump -u ashok -p IPL > /home/ashok/Documents/Backup.sql


                                                      
                                          

