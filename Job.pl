% =========================================
% JOB ELIGIBILITY CHECKER SYSTEM
% =========================================

% =========================================
% 1. CANDIDATE DATA (FACTS)
% =========================================

candidate(john,80,[java,python,sql],2,bsc_it).
candidate(alice,70,[java,python,c,networking,security],3,bsc_it).
candidate(bob,65,[javascript,html,css],1,bsc_it).
candidate(james,35,[python,html,ml,ai,javascript],1,bsc_it).

% =========================================
% 2. JOB REQUIREMENTS (FACTS)
% =========================================

job(software_engineer, [java, python], bsc_it).
job(network_engineer, [networking, security], bsc_it).
job(web_developer, [html, css, javascript], bsc_it).
job(data_analyst, [python, sql], bsc_it).
job(ai_engineer, [python, ai, ml], bsc_it).
job(system_admin, [networking], bsc_it).
job(database_admin, [sql], bsc_it).
job(cyber_security, [security, networking], bsc_it).


% =========================================
% 3. CHECK SKILLS
% =========================================

check_skills([], _).
check_skills([H|T], Skills) :-
    member(H, Skills),
    check_skills(T, Skills).

% =========================================
% 4. SCORE SYSTEM
% =========================================

score(Name, Total) :-
    candidate(Name, Marks, Skills, Exp, _),
    MarksScore is Marks // 10,
    length(Skills, SkillCount),
    ExpScore is Exp * 2,
    Total is MarksScore + SkillCount + ExpScore.

% =========================================
% 5. ELIGIBILITY RULE
% =========================================

eligible(Name, Job) :-
    candidate(Name, _, Skills, _, Quals),
    job(Job, ReqSkills, ReqQuals),

    check_skills(ReqSkills, Skills),
    Quals = ReqQuals,

    score(Name, Score),
    Score >= 12.

% =========================================
% 6. CHECK ALL CANDIDATES
% =========================================

check_all(_, []).
check_all(Job, [C|T]) :-
    ( eligible(C, Job) ->
        write(C), write(' is ELIGIBLE for '), write(Job), nl
    ;
        write(C), write(' is NOT ELIGIBLE for '), write(Job), nl
    ),
    check_all(Job, T).

% =========================================
% 7. GET ALL CANDIDATES
% =========================================

all_candidates(List) :-
    findall(Name, candidate(Name,_,_,_,_), List).

% =========================================
% 8. GET ALL JOBS
% =========================================

all_jobs(List) :-
    findall(Job, job(Job, _, _), List).

% =========================================
% 9. MAIN RUN
% =========================================

run(Job) :-
    nl,
    write('--- Checking for job: '), write(Job), write(' ---'),nl,nl,
    all_candidates(List), 
    check_all(Job, List),
    nl.

% =========================================
% 10. USER INPUT (START)
% =========================================

start :-
    write('==================================='),nl,
    write('      JOB ELIGIBILITY CHECKER      '),nl,
    write('==================================='),nl,nl,
    write('Enter job name (example: software_engineer.)'), nl,nl,
    read(Job),
    ( job(Job,_,_) ->
        run(Job),
        nl,
        write('=============THANK YOU============='),nl
    ;
        write('Invalid job! Try again.'), nl
    ).


% =========================================
% SHOW ELIGIBLE CANDIDATES FOR ONE JOB
% =========================================

show_eligible_for_job(Job) :-
    write('--- Job: '), write(Job), write(' ---'), nl,
    findall(Name, eligible(Name, Job), EligibleList),
    ( EligibleList \= [] ->
        write('Eligible Candidates: '),nl,
        write(EligibleList), nl
    ;
        write('No eligible candidates.'), nl
    ),
    nl.

% =========================================
% RUN FOR ALL JOBS
% =========================================

run_all_jobs :-
    nl,
    write('      ALL JOB ELIGIBILITY RESULTS      '), nl,
    write('_______________________________________'),nl,nl,
    all_jobs(JobList),
    run_jobs(JobList).

run_jobs([]).
run_jobs([J|T]) :-
    show_eligible_for_job(J),
    run_jobs(T).
