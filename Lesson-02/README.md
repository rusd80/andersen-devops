### Lesson 2 - Homework

## Task: Create flask application and deploy it on VM with ansible

1. Provisioning 2 VM's with Vagrant:
    - controlnode: ubuntu 20
    - server: debian 10

2. Created Flask application in folder: Flask

3. I used Docker containerization. Created Dockerfile in folder Flask:

```
FROM python
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
```

4. Ansible playbook in folder ansible: playbook_docker.yml

5. hosts.ini:
```buildoutcfg

```
7. Launch playbook with command:
```buildoutcfg
ansible-playbook playbook_docker.yml -i hosts.ini
```