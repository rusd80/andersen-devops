# DevOps Exam

#### Exam is presented as a self-performed laboratory work.

### Task:
Build a working infrastructure with automatic build and deployment of a new oneversion of the application using dockerization.
Create 2 web applications that output `Hello World
1` and `Hello World 2` in the following languages:
● `Python`
● `.NET Core`
● `PHP`
● `Java`
● `Go (gin framework)`


### You can choose:
Ci / CD, VCS, Registry, Infrasructure.

### Result:
- Working lab that you can demonstrate.
- 20 min presentation.
- Presentation should contain 2 diagrams: how the Ci / CD process works in
your decision
- How would you build it in an ideal world and without 
time limit.
- Presentation should contain a diagram of the infrastructure.

### Additional advantages in solving the problem:
- Code check with an analyzer such as snyk, sonarqube, linter, etc.
- Notification based on results (Telegram bot)
- Automatic pipeline launch on commit / merge request
- Using compiled and non-compiled PL
- Secret management
- Pipeline as code
- Docker registry container policy (scheduled deletions, etc.)
- Logging service
- Automated tests result checking
- README.md

This work is done using `Gitlab-CI`, `SonarQube`, `Telegram`, `AWS Elastic Kubernetes Service cluster`. 
Results are presented on https://gitlab.com