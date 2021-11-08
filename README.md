# ami
，，

using variables to avoid hardcode.

### bash command using to demo

#### Config the credentials of access
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY<br>  
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY<br>
#### Packer code
packer init .  <br>

packer build --var-file=vars.pkrvars.hcl aws-ubuntu.pkr.hcl

nohup java -jar webapp-0.0.1-SNAPSHOT.jar &



