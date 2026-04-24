candidate(john,65,[java,python],2).
candidate(alice,70,[java,python,c],3).
candidate(bob,55,[java],0).
candidate(james,35,[python],1).
% =========================================
% JOB ELIGIBILITY CHECKER SYSTEM
% =========================================

% =========================================
% 1. CANDIDATE DATA (FACTS)
% =========================================

candidate(john,65,[java,python,sql],2,bsc,intermediate,[aws]).
candidate(alice,70,[java,python,c,networking],3,bsc,advanced,[aws,azure]).
candidate(bob,55,[java,html,css],0,diploma,basic,[]).
candidate(james,35,[python,html,css,javascript],1,diploma,intermediate,[]).
candidate(sara,80,[java,python,sql,ai],4,bsc,advanced,[aws,ml]).
candidate(mike,60,[networking,security,linux],2,diploma,intermediate,[ccna]).

% candidate(Name, Marks, Skills, Experience, Degree, English, Certifications)

% =========================================
% 2. JOB REQUIREMENTS (FACTS)
% =========================================

job(software_engineer,
    [java, python],
    bsc,
    intermediate,
    [aws]).

job(network_engineer,
    [networking, security],
    diploma,
    intermediate,
    [ccna]).

job(web_developer,
    [html, css, javascript],
    diploma,
    intermediate,
    []).

job(data_analyst,
    [python, sql],
    bsc,
    intermediate,
    [ml]).

job(ai_engineer,
    [python, ai],
    bsc,
    advanced,
    [ml]).

job(system_admin,
    [networking, linux],
    diploma,
    intermediate,
    [ccna]).

job(database_admin,
    [sql],
    diploma,
    intermediate,
    []).

job(cyber_security,
    [security, networking],
    bsc,
    advanced,
    [ccna]).

% =========================================
% 3. CHECK SKILLS
% =========================================

check_skills([], _).
check_skills([H|T], Skills) :-
    member(H, Skills),
    check_skills(T, Skills).

% =========================================
% 4. CHECK CERTIFICATIONS
% =========================================

check_certs([], _).
check_certs([H|T], Certs) :-
    member(H, Certs),
    check_certs(T, Certs).

% =========================================
% 5. DEGREE CHECK
% =========================================

degree_ok(bsc, bsc).
degree_ok(diploma, diploma).
degree_ok(bsc, diploma).   % higher accepted

% =========================================
% 6. ENGLISH CHECK
% =========================================

english_ok(advanced, _).
english_ok(intermediate, intermediate).
english_ok(intermediate, basic).

% =========================================
% 7. SCORE SYSTEM
% =========================================

score(Name, Total) :-
    candidate(Name, Marks, Skills, Exp, _, _, _),
    MarksScore is Marks // 10,
    length(Skills, SkillCount),
    ExpScore is Exp * 2,
    Total is MarksScore + SkillCount + ExpScore.

% =========================================
% 8. ELIGIBILITY RULE
% =========================================

eligible(Name, Job) :-
    candidate(Name, _, Skills, _, Degree, English, Certs),
    job(Job, ReqSkills, ReqDegree, ReqEnglish, ReqCerts),

    check_skills(ReqSkills, Skills),
    check_certs(ReqCerts, Certs),

    degree_ok(Degree, ReqDegree),
    english_ok(English, ReqEnglish),

    score(Name, Score),
    Score >= 12.

% =========================================
% 9. CHECK ALL CANDIDATES
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
% 10. GET ALL CANDIDATES
% =========================================

all_candidates(List) :-
    findall(Name, candidate(Name,_,_,_,_,_,_), List).

% =========================================
% 11. MAIN RUN
% =========================================

run(Job) :-
    nl,
    write('===== JOB ELIGIBILITY CHECKER ====='), nl,
    all_candidates(List),
    check_all(Job, List),
    nl.

% =========================================
% 12. USER INPUT (START)
% =========================================

start :-
    write('Enter job name (example: software_engineer.)'), nl,
    read(Job),
    ( job(Job,_,_,_,_) ->
        run(Job)
    ;
        write('Invalid job! Try again.'), nl
    ).
