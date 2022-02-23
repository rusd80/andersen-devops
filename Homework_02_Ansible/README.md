### Lesson 2 - Homework

## Task: Create flask application and deploy it on VM with ansible

1. Provisioning 2 VM's with Vagrant according to the Vagrantfile. Use `vagrant up` command.:
    - `controlnode`: ubuntu20 192.168.50.4
    - `server`: debian10 192.168.50.5

2. Created simple Flask application located in folder: `/flask`

3. I used Docker containerization for application deploy. Created Dockerfile located in folder Flask:

```
FROM python
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
```

4. Ansible playbook is located in folder `/ansible`: `playbook_docker.yml`

5. Launch playbook on controlnode with command:
```buildoutcfg
ansible-playbook playbook_docker.yml -i hosts.ini
```