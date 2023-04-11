[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)


<!-- PROJECT LOGO -->
<br />
<div align="center">
    <img width="256" height="256" src="https://user-images.githubusercontent.com/110536677/230987784-c8e55f0e-4434-43b4-8b41-08a8ea8cec08.png" alt="">

<h3 align="center">Execute Python Django within AWS Lambda</h3>

  <p align="center">
   This repository contains a Python Django application designed to run seamlessly inside an AWS Lambda environment, leveraging the AWS Lambda Adapter extension. The application is built to efficiently handle serverless workloads and connect to a PostgreSQL database, providing a scalable, cost-effective, and high-performance solution for modern web applications. By using the AWS Lambda Adapter, the Django app can utilize the event-driven nature of Lambda while maintaining its traditional web application structure.
    </p>
    <br />
    <a href="https://github.com/aws-hebrew-book/reminders/issues">Report Bug</a>
    ·
    <a href="https://github.com/aws-hebrew-book/reminders/issues">Request Feature</a>
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#high-level-architecture">High level architecture</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#database-migration">Database migration</a></li>
        <li><a href="#running-the-app-locally">Running the app locally</a></li>
      </ul>
    </li>
      <li><a href="#behind-the-scenes">Behind the scenes</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## High level architecture

<div align="center">
    <img src="https://user-images.githubusercontent.com/110536677/230990815-91c355a5-9f72-4039-9b3f-ba1090b4839d.png" alt="Architecture diagram">
</div>


## Getting started
### Prerequisites
* Make sure you have [AWS SAM](https://aws.amazon.com/serverless/sam/) installed
* An AWS enviornment.
* Python 3.9 (I highly recommend using [pyenv](https://github.com/pyenv/pyenv#installation)).
* [Python Poetry](https://python-poetry.org/docs/#installation)
* Add [Poe the Poet](https://github.com/nat-n/poethepoet) to Poetry by running `poetry self add 'poethepoet[poetry_plugin]'`


### Installation
* Clone this repository.
* The application uses AWS SAM as IaC framework. 
* Run `poetry install` to install relevant dependencies.
* Run `sam build` and then `sam deploy --guided`. You can use the defaults, the only choice you have to take is the [KeyPair name](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#KeyPairs:). Take note that the default EC2 AMI is located in the `us-east-1` region. If you choose to change the region, ensure that you also update the AMI accordingly.
* Upon completing the installation, you will receive the Lambda endpoint URL and the bastion host's machine details.

### Database migration
Like any DJango application there are some minimal migration steps you need to run - 1. DB migration and 2. Admin user creation. In order to run the relevant commands you need to ssh into the bastion first.
* `ssh -i "MyPrivateKey.pem" ec2-user@ec2-domain`
* Run the following script the install the relevant packages
```
git clone https://github.com/aws-hebrew-book/serverless-django.git
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="/$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
pyenv install 3.9
pyenv global 3.9
curl -sSL https://install.python-poetry.org | python3 -
cd serverless-django
echo 'export PATH="/$HOME/.local/bin:$PATH"' >> ~/.bashrc
poetry install --only main
poetry self add 'poethepoet[poetry_plugin]'
poetry shell
```
* The migration script requires DB user, password and host. The user is the one you supplied during `sam deploy --guided`, the host is one of AWS SAM outputs and the password is stored in the [SecretManager console](https://us-east-1.console.aws.amazon.com/secretsmanager/secret?name=DJangoRDSCredentials&region=us-east-1)
<img width="1302" alt="image" src="https://user-images.githubusercontent.com/110536677/231000112-beb6dae3-5bc9-4d3a-9494-e544a913f805.png">
* Navigate to the `polls` directory
* Run `DB_USER=root DB_PASSWORD=<pass> DB_HOST=<host> python manage.py migrate`. This will create relevant tables.
* Next is creating admin user. Run `DB_USER=root DB_PASSWORD=<pass> DB_HOST=<host> python manage.py createsuperuser`.
* Need to add the supported hosts otherwise django will fail with 400. Add an environment variable to your Lambda named `DJANGO_ALLOWED_HOSTS` and set its value to the lambda URL host 
* Try `https://<lambda host>/admin` and login using the super user credentials you just created.

### Running the app locally
* The application use `docker-compose` to run the application locally.
* Run `docker-compose up` and you are good to go.

## Behind the scenes
### Lambda Web Adapter
Django for Python operates differently from AWS Lambda, as Django functions as a traditional web server that waits for external connections, while Lambda is event-based. To bridge the gap between these two operation types, the [Lambda Web Adapter](https://github.com/awslabs/aws-lambda-web-adapter) extension is required. This extension serves as a mediator, translating the http request coming from API Gateway or Lambda URL into a web request that is done against the internal guinicorn process.
![image](https://user-images.githubusercontent.com/110536677/231006553-291de4a2-44a8-4622-bcef-fb7cdb894bc2.png)

### Consuming AWS Services
When migrating an application to the cloud, it presents an excellent opportunity to leverage other cloud services. In this example, we utilize AWS Secret Manager to store the database password and the Django secret key. To retrieve the secret values and integrate them into the Django app, we employ [Lambda Power Tools](https://awslabs.github.io/aws-lambda-powertools-python/2.12.0/utilities/parameters/#fetching-secrets) , simplifying the process of securely accessing these sensitive pieces of information.

One of the challenges when using traditional web applications that rely on SQL databases is the requirement to be within a VPC. By default, a Lambda function within a private subnet cannot access the internet and, therefore, cannot access AWS services. There are two ways to address this issue:

1. Utilize an Internet Gateway and NAT to enable compute resources in the private subnet to access the internet.
2. Use [VPC endpoints](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html), as Secret Manager supports [VPC endpoints](https://docs.aws.amazon.com/secretsmanager/latest/userguide/vpc-endpoint-overview.html).
The current solution opts for the first option due to its simplicity; however, it is less secure because it exposes the Lambda function to the internet rather than limiting access to specific AWS services.

### Serving Static Files
Django is an all-inclusive framework that not only handles backend processes but also supports frontend server-side rendering. This means that web pages can be rendered using the framework, even when developing Single Page Applications (SPAs) and using Django as a REST backend. One issue that requires attention is static file handling, such as serving JS or CSS files.
<img width="950" alt="image" src="https://user-images.githubusercontent.com/110536677/231078369-42bd25e9-2c1b-450c-9a55-a51624a8b354.png">


AWS recommends managing static files using S3 and CloudFront. One approach is to use [django-storages](https://github.com/jschneier/django-storages), define S3 as a storage backend, and then set the S3 as the source for the CloudFront distribution. Alternatively, you can serve static files directly through the web server (using Gunicorn and the AWS Lambda Adapter), which is simpler and, in cases where only the admin panel needs support, is often preferable. To serve static files directly through the web server, simply use Django [WhiteNoise](https://whitenoise.readthedocs.io/en/latest/) and add it as middleware.


## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the Apache License Version 2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Efi Merdler-Kravitz - [@TServerless](https://twitter.com/TServerless)



<p align="right">(<a href="#readme-top">back to top</a>)</p>

